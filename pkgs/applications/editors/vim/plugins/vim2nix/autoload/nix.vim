" usage example:
"
" call nix#ExportPluginsForNix({'path_to_nixpkgs': '/etc/nixos/nixpkgs', 'names': ["vim-addon-manager", "vim-addon-nix"], 'cache_file': 'cache'})
let s:plugin_root = expand('<sfile>:h:h')

fun! nix#ToNixAttrName(s) abort
    return nix#ToNixName(a:s)
endf

fun! nix#ToNixName(s) abort
  return substitute(substitute(a:s, '[:/.]', '-', 'g'), 'github-', '', 'g')
endf

fun! s:System(...)
  let args = a:000
  let r = call('vam#utils#System', args)
  if r is 0
    throw "command ".join(args, '').' failed'
  else
    return r
  endif
endf

fun! nix#DependenciesFromCheckout(opts, name, repository, dir)
  " check for dependencies
  " vam#PluginDirFromName(a:name)
  let info = vam#ReadAddonInfo(vam#AddonInfoFile(a:dir, a:name))
  return keys(get(info, 'dependencies', {}))
endf


" without deps
fun! nix#NixDerivation(opts, name, repository) abort
  let n_a_name = nix#ToNixAttrName(a:name)
  let n_n_name = nix#ToNixName(a:name)
  let type = get(a:repository, 'type', '')
  let created_notice = " # created by nix#NixDerivation"

  let ancf = s:plugin_root.'/additional-nix-code/'.a:name
  let additional_nix_code = file_readable(ancf) ? join(readfile(ancf), "\n") : ""

  if type == 'git'
    " should be using shell abstraction ..
    echo 'fetching '. a:repository.url
    let s = s:System('$ --fetch-submodules $ 2>&1',a:opts.nix_prefetch_git, a:repository.url)
    let rev = matchstr(s, 'git revision is \zs[^\n\r]\+\ze')
    let sha256 = matchstr(s, 'hash is \zs[^\n\r]\+\ze')
    let dir = matchstr(s, 'path is \zs[^\n\r]\+\ze')
    let date = matchstr(s, 'Commit date is \zs[0-9-]\+\ze')

    let dependencies = nix#DependenciesFromCheckout(a:opts, a:name, a:repository, dir)
    return {'n_a_name': n_a_name, 'n_n_name': n_n_name, 'dependencies': dependencies, 'derivation': join([
          \ '  '.n_a_name.' = buildVimPlugin {'.created_notice,
          \ '    name = "'.n_n_name.'-'.date.'";',
          \ '    src = fetchgit {',
          \ '      url = "'. a:repository.url .'";',
          \ '      rev = "'.rev.'";',
          \ '      sha256 = "'.sha256.'";',
          \ '    };',
          \ '    dependencies = ['.join(map(copy(dependencies), "'\"'.nix#ToNixAttrName(v:val).'\"'")).'];',
          \ additional_nix_code,
          \ '  };',
          \ '',
          \ '',
          \ ], "\n")}

  elseif type == 'hg'
    " should be using shell abstraction ..
    echo 'fetching '. a:repository.url
    let s = s:System('$ $ 2>&1',a:opts.nix_prefetch_hg, a:repository.url)
    let rev = matchstr(s, 'hg revision is \zs[^\n\r]\+\ze')
    let sha256 = matchstr(s, 'hash is \zs[^\n\r]\+\ze')
    let dir = matchstr(s, 'path is \zs[^\n\r]\+\ze')

    let dependencies = nix#DependenciesFromCheckout(a:opts, a:name, a:repository, dir)
    return {'n_a_name': n_a_name, 'n_n_name': n_n_name, 'dependencies': dependencies, 'derivation':  join([
          \ '  '.n_a_name.' = buildVimPlugin {'.created_notice,
          \ '    name = "'.n_n_name.'";',
          \ '    src = fetchhg {',
          \ '      url = "'. a:repository.url .'";',
          \ '      rev = "'.rev.'";',
          \ '      sha256 = "'.sha256.'";',
          \ '    };',
          \ '    dependencies = ['.join(map(copy(dependencies), "'\"'.nix#ToNixAttrName(v:val).'\"'")).'];',
          \ additional_nix_code,
          \ '  };',
          \ '',
          \ '',
          \ ], "\n")}

  elseif type == 'archive'
    let sha256 = split(s:System('nix-prefetch-url $ 2>/dev/null', a:repository.url), "\n")[0]
    " we should unpack the sources, look for the addon-info.json file ..
    " however most packages who have the addon-info.json file also are on
    " github thus will be of type "git" instead. The dependency information
    " from vim-pi is encoded in the reposiotry. Thus this is likely to do the
    " right thing most of the time.
    let addon_info = get(a:repository, 'addon-info', {})
    let dependencies = keys(get(addon_info, 'dependencies', {}))

    return {'n_a_name': n_a_name, 'n_n_name': n_n_name, 'dependencies': dependencies, 'derivation':  join([
          \ '  '.n_a_name.' = buildVimPlugin {'.created_notice,
          \ '    name = "'.n_n_name.'";',
          \ '    src = fetchurl {',
          \ '      url = "'. a:repository.url .'";',
          \ '      name = "'. a:repository.archive_name .'";',
          \ '      sha256 = "'.sha256.'";',
          \ '    };',
          \ '    buildInputs = [ unzip ];',
          \ '    dependencies = ['.join(map(copy(dependencies), "'\"'.nix#ToNixAttrName(v:val).'\"'")).'];',
          \ '    meta = {',
          \ '       homepage = "http://www.vim.org/scripts/script.php?script_id='.a:repository.vim_script_nr.'";',
          \ '    };',
          \ addon_info == {} ? '' : ('    addon_info = '.nix#ToNix(string(addon_info), [], "").';'),
          \ additional_nix_code,
          \ '  };',
          \ '',
          \ '',
          \ ], "\n")}
  else
    throw a:name.' TODO: implement source '.string(a:repository)
  endif
endf

" also tries to handle dependencies
fun! nix#AddNixDerivation(opts, cache, name, ...) abort
  if has_key(a:cache, a:name) | return | endif
  let repository = a:0 > 0 ? a:1 : {}
  let name = a:name

  if repository == {}
    call vam#install#LoadPool()
    let list = matchlist(a:name, 'github:\([^/]*\)\%(\/\(.*\)\)\?$')
    if len(list) > 0
      if '' != list[2]
        let name = list[2]
        let repository = { 'type': 'git', 'owner': list[1], 'repo': list[2], 'url': 'https://github.com/'.list[1].'/'.list[2] }
      else
        let name = list[1]
        let repository = { 'type': 'git', 'owner': list[1], 'repo': 'vim-addon-'.list[1], 'url': 'https://github.com/'.list[1].'/vim-addon-'.list[1] }
      endif
    else
      let repository = get(g:vim_addon_manager.plugin_sources, a:name, {})
      if repository == {}
        throw "repository ".a:name." unkown!"
      else
          if repository.url =~ 'github'
            let owner = matchstr(repository.url, 'github.com/\zs.\+\ze/')
            let repo = matchstr(repository.url, '\/\zs[^\/]\+\ze$')
            let url = repository.url
            let repository = { 'type': 'git', 'owner': owner, 'repo': repo, 'url': url }
          endif
      endif
    endif
  endif

  let a:cache[a:name] = nix#NixDerivation(a:opts, name, repository)

  " take known dependencies into account:
  let deps = get(a:cache[a:name], 'dependencies', [])
  call extend(a:opts.names_to_process, deps)
  call extend(a:opts.names_to_export,  deps)
endfun

fun! nix#TopNixOptsByParent(parents)
  if (a:parents == [])
    return {'ind': '  ', 'next_ind': '    ', 'sep': "\n"}
  else
    return {'ind': '', 'next_ind': '', 'sep': ' '}
  endif
endf

fun! nix#ToNix(x, parents, opts_fun) abort
  let opts = a:opts_fun == "" ? "" : call(a:opts_fun, [a:parents])
  let next_parents = [a:x] + a:parents
  let seps = a:0 > 1 ? a:2 : []

  let ind = get(opts, 'ind', '')
  let next_ind = get(opts, 'next_ind', ind.'  ')
  let sep = get(opts, 'sep', ind.'  ')

  if type(a:x) == type("")
    return "''". substitute(a:x, '[$]', '$$', 'g')."''"
  elseif type(a:x) == type({})
    let s = ind."{".sep
    for [k,v] in items(a:x)
      let s .= '"'.k.'" = '.nix#ToNix(v, next_parents, a:opts_fun).";".sep
      unlet k v
    endfor
    return  s.ind."}"

    " let s = ind."{\n"
    " for [k,v] in items(a:x)
    "   let s .= next_ind . nix#ToNix(k).' = '.nix#ToNix(v, next_ind)."\n"
    "   unlet k v
    " endfor
    " return  s.ind."}\n"
  elseif type(a:x) == type([])
    let s = ind."[".sep
    for v in a:x
      let s .= next_ind . nix#ToNix(v, next_parents, a:opts_fun)."".sep
      unlet v
    endfor
    return s.ind."]"
  endif
endf


" with dependencies
" opts.cache_file (caches the checkout and dependency information
" opts.path_to_nixpkgs or  opts.nix_prefetch_{git,hg}
" opts.plugin_dictionaries: list of any
"     - string
"     - dictionary having key name or names
" This is so that plugin script files can be loaded/ merged
fun! nix#ExportPluginsForNix(opts) abort
  let cache_file = get(a:opts, 'cache_file', '')

  let opts = a:opts

  " set nix_prefetch_* scripts
  for scm in ['git', 'hg']
    if !has_key(opts, 'nix_prefetch_'.scm)
      let opts['nix_prefetch_'.scm] = a:opts.path_to_nixpkgs.'/pkgs/build-support/fetch'.scm.'/nix-prefetch-'.scm
    endif
  endfor

  " create list of names from dictionaries
  let a:opts.names_to_process = []
  for x in a:opts.plugin_dictionaries
    if type(x) == type('')
      call add(opts.names_to_process, x)
    elseif type(x) == type({}) && has_key(x, 'name')
      call add(opts.names_to_process, x.name)
    elseif type(x) == type({}) && has_key(x, 'names')
      call extend(opts.names_to_process, x.names)
    else
      throw "unexpected"
    endif
    unlet x
  endfor
  let a:opts.names_to_export = a:opts.names_to_process

  let cache = (cache_file == '' || !filereadable(cache_file)) ? {} : eval(readfile(cache_file)[0])
  let failed = {}
  while len(opts.names_to_process) > 0
    let name = opts.names_to_process[0]
    if get(opts, 'try_catch', 1)
      try
        call nix#AddNixDerivation(opts, cache, name)
      catch /.*/
        echom 'failed : '.name.' '.v:exception
        let failed[name] = v:exception
      endtry
    else
      call nix#AddNixDerivation(opts, cache, name)
    endif
    let opts.names_to_process = opts.names_to_process[1:]
  endwhile
  echom join(keys(failed), ", ")
  echom string(failed)

  if cache_file != ''
    call writefile([string(cache)], cache_file)
  endif

  enew

  let uniq = {}
  for x in a:opts.names_to_export
    let uniq[x] = 1
  endfor

  for k in sort(keys(uniq))
    call append('$', split(cache[k].derivation,"\n"))
  endfor

  " for VAM users output vam.pluginDictionaries which can be fed to
  " vim_customizable.customize.vimrc.vam.pluginDictionaries
  call append('$', ["", "", "", '# vam.pluginDictionaries'])

  let ns = []
  for x in a:opts.plugin_dictionaries
    if type(x) == type("")
      call add(ns, nix#ToNixAttrName(x))
    elseif type(x) == type({})
      if has_key(x, 'name')
        call add(ns, extend({'name': nix#ToNixAttrName(x.name)}, x, "keep"))
      elseif has_key(x, 'names')
        call add(ns, extend({'names': map(copy(x.names), 'nix#ToNixAttrName(v:val)')}, x, "keep"))
      else
        throw "unexpected"
      endif
    else
      throw "unexpected"
    endif
    unlet x
  endfor

  call append('$', split(nix#ToNix(ns, [], 'nix#TopNixOptsByParent'), "\n"))

  " failures:
  for [k,v] in items(failed)
    call append('$', ['# '.k.', failure: '.v])
    unlet k v
  endfor
endf
