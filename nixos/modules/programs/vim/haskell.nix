{pkgs,...}:
{
  ###### interface
  options = {
    getType = {
      default = "<Leader>ht";
      description = "Keymap for getting Haskell type under cursor.";
    };
    
    insertType = {
      default = "<Leader>hi";
      description = "Keymap to query and to insert Haskell type under cursor.";
    };

    check = {
      default = "<Leader>hc";
      description = "Keymap to trigger syntax checking.";
    };

    lint = {
      default = "<Leader>hl";
      description = "Keymap to trigger code linting.";
    };

    error = {
      default = "<Leader>he";
      description = "Keymap to open window with errors and warnings.";
    };

    clear = {
      default = "<Leader><BS>";
      description = "Keymap to clear and close all preview or helper windows.";
    };

    hoogle = {
      default = "<Leader>hh";
      description = "Keymap to hoogle word under cursor.";
    };

    hoogleInfo = {
      default = "<Leader>ho";
      description = "Keymap to hoogle infos for word under cursor.";
    };

    hooglePrompt = {
      default = "<Leader>hH";
      description = "Keymap to get hoogle prompt.";
    };

    hoogleInfoPrompt = {
      default = "<Leader>hO";
      description = "Keymap to get hoogle info prompt.";
    };

    pointfree = {
      default = "<Leader>h.";
      description = "Keymap to convert selection into pointfree style.";
    };

    pointful = {
      default = "<Leader>h>";
      description = "Keymap to convert selection into pointful style.";
    };

  };

  ###### implementation

  vimrc = cfg: ''
    filetype on
    filetype plugin on
    filetype indent on
    setfiletype haskell
    
    
    " vim2hs: Pretty unicode haskell symbols
    let g:haskell_conceal_wide = 1
    let g:haskell_conceal_enumerations = 1
    " alterantive to vim2hs would be hasksyn
    
    " Enable some tabular presets for Haskell
    let g:haskell_tabular = 1
    
    
    " integrate necoghc into completion; should work with YouCompleteMe; necoghc requires Cabal, which is in ghc, in paths below
    setlocal omnifunc=necoghc#omnifunc
    let g:ycm_semantic_triggers = {'haskell' : ['.']}
    " Show types in completion suggestions
    let g:necoghc_enable_detailed_browse = 1

    '' + (if isNull cfg.getType then "" else ''
    " Type of expression under cursor
    nmap <silent> ${cfg.getType} :HdevtoolsType<CR>
    '') + (if isNull cfg.insertType then "" else ''
    " Insert type of expression under cursor
    nmap <silent> ${cfg.insertType} :GhcModTypeInsert<CR>

    '') + (if (isNull cfg.check) && (isNull cfg.lint) then "" else ''
    let g:syntastic_mode_map = { 'mode': 'passive', 'passive_filetypes': ['haskell'] }
    let g:syntastic_enable_signs = 1
    let g:syntastic_aggregate_errors = 1
    let g:syntastic_id_checkers = 0
    let g:syntastic_sort_aggregated_errors = 0
    let g:syntastic_haskell_checkers = [ 'hdevtools', 'hlint' ]
    "let g:syntastic_ignore_files = []
    
    '') + (if isNull cfg.check then "" else ''
    " GHC errors and warnings
    nmap <silent> ${cfg.check} :SyntasticCheck hdevtools<CR>
    '') + (if isNull cfg.lint then "" else ''
    " Haskell Lint
    nmap <silent> ${cfg.lint} :SyntasticCheck hlint<CR>
    '') + (if (isNull cfg.check) && (isNull cfg.lint) && (isNull cfg.error) then "" else ''
    " show syntastic error window
    nmap <silent> ${cfg.error} :Errors<CR>

    '') + (if isNull cfg.hoogle then "" else ''
    " Hoogle the word under the cursor
    nnoremap <silent> ${cfg.hoogle} :Hoogle<CR>

    '') + (if isNull cfg.hoogleInfo then "" else ''
    " Hoogle for detailed documentation (e.g. "Functor")
    nnoremap <silent> ${cfg.hoogleInfo} :HoogleInfo<CR>

    '') + (if isNull cfg.hooglePrompt then "" else ''
    " Hoogle and prompt for input
    nnoremap ${cfg.hooglePrompt} :Hoogle
    
    '') + (if isNull cfg.hoogleInfoPrompt then "" else ''
    " Hoogle for detailed documentation and prompt for input
    nnoremap ${cfg.hoogleInfoPrompt} :HoogleInfo
    
    '') + (if (isNull cfg.check) && (isNull cfg.lint) && (isNull cfg.hoogle) && (isNull cfg.hoogleInfo)
            && (isNull cfg.hooglePrompt) && (isNull cfg.hoogleInfoPrompt) && (isNull cfg.clear) then "" else ''
    " clear/reset
    map <silent> ${cfg.clear} :noh<cr>:GhcModTypeClear<cr>:SyntasticReset<cr>:HdevtoolsClear<cr>:HoogleClose<cr>
    
    
    '') + (if isNull cfg.pointfree then "" else ''
    " pointfree
    function! Pointfree()
      call setline('.', split(system('pointfree '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
    endfunction
    vnoremap <silent> ${cfg.pointfree} :call Pointfree()<CR>
    
    '') + (if isNull cfg.pointful then "" else ''
    " pointful
    function! Pointful()
      call setline('.', split(system('pointful '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
    endfunction
    vnoremap <silent> ${cfg.pointful} :call Pointful()<CR>
    '') + ''
    
    let g:ycm_server_use_vim_stdout = 1
    let g:ycm_server_log_level = 'debug'

    function! TestVimproc()
      let l:ghcmod = vimproc#system(['ghc-mod','version'])
      let l:m = matchlist(l:ghcmod, 'version \(\d\+\)\.\(\d\+\)\.\(\d\+\)')
      let s:ghc_mod_version = l:m[1 : 3]
      call map(s:ghc_mod_version, 'str2nr(v:val)')
      return s:ghc_mod_version
    endfunction


    
    " configure cscope for use with Haskell
    set cscopeprg=hscope
    
    " add the database pointed to by environment variable 
    "  suppress 'duplicate connection' error
    set nocscopeverbose
    if !empty("$NIX_HASKELL_HSCOPE")
        cs add $NIX_HASKELL_HSCOPE
    " else add any cscope database in current directory
    elseif filereadable("hscope.out")
        cs add hscope.out  
    endif
    set cscopeverbose
    
    " add haskell tags file to by environment variable 
    if !empty("$NIX_HASKELL_HTAGS")
        set tags=$NIX_HASKELL_HTAGS
    " else add haskell tags in the current directory
    elseif filereadable("htags")
        set tags=htags  
    endif
    
    
    " Tagbar settings
    let g:tagbar_type_haskell = {
        \ 'ctagsbin' : 'lushtags',
        \ 'ctagsargs' : '--ignore-parse-error --',
        \ 'kinds' : [
            \ 'm:module:0',
            \ 'e:exports:1',
            \ 'i:imports:1',
            \ 't:declarations:0',
            \ 'd:declarations:1',
            \ 'n:declarations:1',
            \ 'f:functions:0',
            \ 'c:constructors:0'
        \ ],
        \ 'sro' : '.',
        \ 'kind2scope' : {
            \ 'd' : 'data',
            \ 'n' : 'newtype',
            \ 'c' : 'constructor',
            \ 't' : 'type'
        \ },
        \ 'scope2kind' : {
            \ 'data' : 'd',
            \ 'newtype' : 'n',
            \ 'constructor' : 'c',
            \ 'type' : 't'
        \ }
    \ }
    
    
    "let g:tagbar_type_haskell = {
    "    \ 'ctagsbin'  : 'hasktags',
    "    \ 'ctagsargs' : '-x -c -o-',
    "    \ 'kinds'     : [
    "        \  'm:modules:0:1',
    "        \  'd:data: 0:1',
    "        \  'd_gadt: data gadt:0:1',
    "        \  't:type names:0:1',
    "        \  'nt:new types:0:1',
    "        \  'c:classes:0:1',
    "        \  'cons:constructors:1:1',
    "        \  'c_gadt:constructor gadt:1:1',
    "        \  'c_a:constructor accessors:1:1',
    "        \  'ft:function types:1:1',
    "        \  'fi:function implementations:0:1',
    "        \  'o:others:0:1'
    "    \ ],
    "    \ 'sro'        : '.',
    "    \ 'kind2scope' : {
    "        \ 'm' : 'module',
    "        \ 'c' : 'class',
    "        \ 'd' : 'data',
    "        \ 't' : 'type'
    "    \ },
    "    \ 'scope2kind' : {
    "        \ 'module' : 'm',
    "        \ 'class'  : 'c',
    "        \ 'data'   : 'd',
    "        \ 'type'   : 't'
    "    \ }
    "\ }
  '';

  plugins = [ "hdevtools" "ghcmod" "vimproc" "syntastic" "hoogle" "stylishHaskell" "necoGhc" "vim2hs" "hasksyn" "haskellConceal" ];

  paths = with pkgs; [ haskellPackages.ghc haskellPackages.hdevtools haskellPackages.ghcMod haskellPackages.stylishHaskell
                       haskellPackages.hlint haskellPackages.pointfree haskellPackages.pointful haskellPackages.hoogle
                       haskellPackages.lushtags coreutils haskellPackages.c2hs ];
}

