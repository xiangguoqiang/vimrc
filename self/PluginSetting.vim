" add tag to tag search path
function! s:AddTag(path)
    let cp = fnamemodify(a:path, ':p:h')
    let p = fnamemodify(cp, ':p:h') . '/tags'
    if filereadable(p) && index(split(&tags, ','), p) < 0
        let &tags = &tags . ', ' . p
    endif
    let pp = fnamemodify(cp, ':p:h:h')
    if cp != pp
        call s:AddTag(pp)
    endif
endfunction

autocmd BufEnter *.java call s:AddTag('.')
autocmd BufEnter *.c call s:AddTag('.')
autocmd BufEnter *.cpp call s:AddTag('.')

" yankring
let g:yankring_history_file = '.yankring_history_file'

let g:pymode_lint_ignore = "E128"

map <C-M> :CtrlPMRUFiles<CR>
map <leader><leader> :CtrlPBookmarkDir<CR>

function! CtrlPSrcRoot()
    let src = g:SrcRoot()
    execute ':CtrlP ' . src
endfunction
nmap <C-Z> :call CtrlPSrcRoot()<CR>

let g:ctrlp_ignore_dirs = ["build", "res", "bin", "Bin", "obj", "Obj", "debug", "Debug", "__pycache__", "gen", "drawable.\+", "\.git", "\.svn"]
let g:ctrlp_custom_ignore = ''
let s:sperator = ''
for dir in g:ctrlp_ignore_dirs
    let g:ctrlp_custom_ignore = g:ctrlp_custom_ignore . s:sperator . '\<' . dir . '\>'
    let s:sperator = '\|'
endfor

let g:NERDTreeIgnore = []
" common dot files
call extend(g:NERDTreeIgnore, ['.git[[dir]]'])
call extend(g:NERDTreeIgnore, ['.svn[[dir]]'])
" C#/CPP project build files
call extend(g:NERDTreeIgnore, ['^bin$[[dir]]'])
call extend(g:NERDTreeIgnore, ['obj[[dir]]'])
call extend(g:NERDTreeIgnore, ['Obj[[dir]]'])
call extend(g:NERDTreeIgnore, ['Debug[[dir]]'])
" python project
call extend(g:NERDTreeIgnore, ['__pycache__[[dir]]'])
call extend(g:NERDTreeIgnore, ['.pyc[[file]]'])
" android NERDTree setting
call extend(g:NERDTreeIgnore, ['^.settings$[[dir]]'])
call extend(g:NERDTreeIgnore, ['^drawable.\+[[dir]]'])
call extend(g:NERDTreeIgnore, ['^exlibs$[[dir]]'])
call extend(g:NERDTreeIgnore, ['^gen$[[dir]]'])
call extend(g:NERDTreeIgnore, ['^libs$[[dir]]'])

" ack.vim
let g:ack_default_options = " -s -H --nogroup --column --smart-case --follow"
if executable('ag')
    let g:ackprg='/usr/local/bin/ag --vimgrep'
endif

" function to use ack.vim
function! s:A(pattern, ...)
    if a:0 > 0
        let l:searchDir = a:000[0]
    else
        let l:searchDir = g:SrcRoot()
    endif
    exec 'Ack! "' . a:pattern . '" ' . l:searchDir
endfunction

command! -nargs=+ A call s:A(<q-args>)
function! s:AckWithGit()
    let l:searchDir = g:SrcRoot()
    let l:word = expand('<cword>')
    exec 'Ack! "' . l:word . '" ' . l:searchDir
endfunction
map <F4> :call s:AckWithGit()<CR>

" easymotion 配置
map <Leader> <Plug>(easymotion-prefix)
let g:EasyMotion_smartcase = 1
map  <leader>/ <Plug>(easymotion-sn)
omap <leader>/ <Plug>(easymotion-tn)

" JK motions: Line motions
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion

" easy to use NERDTree
map <leader>e :NERDTreeToggle %:p:h<CR>
map <leader>m :NERDTreeFind<CR>

map <leader>F :FufFile<CR>
map <leader>B :FufBuffer<CR>
map <leader>J :FufJumpList<CR>

" fugitive settings.
autocmd BufNewFile,BufRead COMMIT_EDITMSG :startinsert!
nmap <leader>ga :Git add --patch<CR>
nmap <leader>gs :Gstatus<CR>
nmap <leader>gc :Gcommit<CR>

nnoremap <leader>fu :CtrlPFunky<CR>
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<CR>
let g:ctrlp_funky_matchtype = 'path'
let g:ctrlp_working_path_mode = 'wra'
au VimEnter * AirlineTheme powerlineish
let g:pymode_options_max_line_length = 100
let g:pep8_ignore="E501,W601"
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_flake8_args='--ignore=E501,E225'
let g:pymode_folding = 0

let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}
let g:pymode_lint_options_pylint = {'max-line-length': g:pymode_options_max_line_length}
let g:pymode_lint_options_pycodestyle = {'max_line_length': g:pymode_options_max_line_length}
