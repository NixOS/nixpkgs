# tests available at pkgs/test/vim
{ lib, stdenv, vim, vimPlugins, vim_configurable, buildEnv, writeText, writeScriptBin
, nix-prefetch-hg, nix-prefetch-git
, fetchFromGitHub, runtimeShell
, hasLuaModule
, python3
, callPackage, makeSetupHook
}:

/*

USAGE EXAMPLE
=============

Install Vim like this eg using nixos option environment.systemPackages which will provide
vim-with-plugins in PATH:

  vim_configurable.customize {
    name = "vim-with-plugins";

    # add custom .vimrc lines like this:
    vimrcConfig.customRC = ''
      set hidden
    '';

    # store your plugins in Vim packages
    vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
      # loaded on launch
      start = [ youcompleteme fugitive ];
      # manually loadable by calling `:packadd $plugin-name`
      opt = [ phpCompletion elm-vim ];
      # To automatically load a plugin when opening a filetype, add vimrc lines like:
      # autocmd FileType php :packadd phpCompletion
    };

    # plugins can also be managed by VAM
    vimrcConfig.vam.knownPlugins = pkgs.vimPlugins; # optional
    vimrcConfig.vam.pluginDictionaries = [
      # load always
      { name = "youcompleteme"; }
      { names = ["youcompleteme" "foo"]; }

      # only load when opening a .php file
      { name = "phpCompletion"; ft_regex = "^php\$"; }
      { name = "phpCompletion"; filename_regex = "^.php\$"; }

      # provide plugin which can be loaded manually:
      { name = "phpCompletion"; tag = "lazy"; }

      # full documentation at github.com/MarcWeber/vim-addon-manager
    ];

    # there is a pathogen implementation as well, but its startup is slower and [VAM] has more feature
    # vimrcConfig.pathogen.knownPlugins = vimPlugins; # optional
    # vimrcConfig.pathogen.pluginNames = ["vim-addon-nix"];
  };

WHAT IS A VIM PLUGIN?
=====================
Typical plugin files:

  plugin/P1.vim
  autoload/P1.vim
  ftplugin/xyz.vim
  doc/plugin-documentation.txt (traditional documentation)
  README(.md) (nowadays thanks to github)


Vim offers the :h rtp setting which works for most plugins. Thus adding
this to your .vimrc should make most plugins work:

  set rtp+=~/.nix-profile/share/vim-plugins/youcompleteme
  " or for p in ["youcompleteme"] | exec 'set rtp+=~/.nix-profile/share/vim-plugins/'.p | endfor

which is what the [VAM]/pathogen solutions above basically do.

Learn about about plugin Vim plugin mm managers at
http://vim-wiki.mawercer.de/wiki/topic/vim%20plugin%20managment.html.

The documentation can be accessed by Vim's :help command if it was tagged.
See vimHelpTags sample code below.

CONTRIBUTING AND CUSTOMIZING
============================
The example file pkgs/applications/editors/vim/plugins/default.nix provides
both:
* manually mantained plugins
* plugins created by VAM's nix#ExportPluginsForNix implementation

I highly recommend to lookup vim plugin attribute names at the [vim-pi] project
 which is a database containing all plugins from
vim.org and quite a lot of found at github and similar sources. vim-pi's documented purpose
is to associate vim.org script ids to human readable names so that dependencies
can be describe easily.

How to find a name?
  * http://vam.mawercer.de/ or VAM's
  * grep vim-pi
  * use VAM's completion or :AddonsInfo command

It might happen than a plugin is not known by vim-pi yet. We encourage you to
contribute to vim-pi so that plugins can be updated automatically.


CREATING DERVITATIONS AUTOMATICALLY BY PLUGIN NAME
==================================================
Most convenient is to use a ~/.vim-scripts file putting a plugin name into each line
as documented by [VAM]'s README.md
It is the same format you pass to vimrcConfig.vam.pluginDictionaries from the
usage example above.

Then create a temp vim file and insert:

  let opts = {}
  let opts.path_to_nixpkgs = '/etc/nixos/nixpkgs'
  let opts.cache_file = '/tmp/export-vim-plugin-for-nix-cache-file'
  let opts.plugin_dictionaries = map(readfile("vim-plugins"), 'eval(v:val)')
  " add more files
  " let opts.plugin_dictionaries += map(.. other file )
  call nix#ExportPluginsForNix(opts)

Then ":source %" it.

nix#ExportPluginsForNix is provided by ./vim2nix

A buffer will open containing the plugin derivation lines as well list
fitting the vimrcConfig.vam.pluginDictionaries option.

Thus the most simple usage would be:

  vim_with_plugins =
    let vim = vim_configurable;
        inherit (vimUtil.override {inherit vim}) rtpPath addRtp buildVimPlugin vimHelpTags;
        vimPlugins = [
          # the derivation list from the buffer created by nix#ExportPluginsForNix
          # don't set which will default to pkgs.vimPlugins
        ];
    in vim.customize {
      name = "vim-with-plugins";

      vimrcConfig.customRC = '' .. '';

      vimrcConfig.vam.knownPlugins = vimPlugins;
      vimrcConfig.vam.pluginDictionaries = [
          # the plugin list form ~/.vim-scripts turned into nix format added to
          # the buffer created by the nix#ExportPluginsForNix
      ];
    }

vim_with_plugins can be installed like any other application within Nix.

[VAM]    https://github.com/MarcWeber/vim-addon-manager
[vim-pi] https://bitbucket.org/vimcommunity/vim-pi
*/


let
  inherit lib;

  # make sure a plugin is a derivation and its dependencies are derivations. If
  # plugin already is a derivation, this is a no-op. If it is a string, it is
  # looked up in knownPlugins.
  pluginToDrv = knownPlugins: plugin:
  let
    drv =
      if builtins.isString plugin then
        # make sure `pname` is set to that we are able to convert the derivation
        # back to a string.
        ( knownPlugins.${plugin} // { pname = plugin; })
      else
        plugin;
  in
    # make sure all the dependencies of the plugin are also derivations
    drv // { dependencies = map (pluginToDrv knownPlugins) (drv.dependencies or []); };

  # transitive closure of plugin dependencies (plugin needs to be a derivation)
  transitiveClosure = plugin:
    [ plugin ] ++ (
      lib.unique (builtins.concatLists (map transitiveClosure plugin.dependencies or []))
    );

  findDependenciesRecursively = plugins: lib.concatMap transitiveClosure plugins;

  vamDictToNames = x:
      if builtins.isString x then [x]
      else (lib.optional (x ? name) x.name)
            ++ (x.names or []);

  rtpPath = ".";

  # Generates a packpath folder as expected by vim
  packDir = packages:
  let
    # dir is "start" or "opt"
    linkLuaPlugin = plugin: packageName: dir: ''
      mkdir -p $out/pack/${packageName}/${dir}/${plugin.pname}/lua
      ln -sf ${plugin}/share/lua/5.1/* $out/pack/${packageName}/${dir}/${plugin.pname}/lua
      ln -sf ${plugin}/${plugin.pname}-${plugin.version}-rocks/${plugin.pname}/${plugin.version}/* $out/pack/${packageName}/${dir}/${plugin.pname}/
    '';

    linkVimlPlugin = plugin: packageName: dir: ''
      mkdir -p $out/pack/${packageName}/${dir}
      if test -e "$out/pack/${packageName}/${dir}/${lib.getName plugin}"; then
        printf "\nERROR - Duplicated vim plugin: ${lib.getName plugin}\n\n"
        exit 1
      fi
      ln -sf ${plugin}/${rtpPath} $out/pack/${packageName}/${dir}/${lib.getName plugin}
    '';

    link = pluginPath: if hasLuaModule pluginPath
      then linkLuaPlugin pluginPath
      else linkVimlPlugin pluginPath;

    packageLinks = packageName: {start ? [], opt ? []}:
    let
      # `nativeImpl` expects packages to be derivations, not strings (as
      # opposed to older implementations that have to maintain backwards
      # compatibility). Therefore we don't need to deal with "knownPlugins"
      # and can simply pass `null`.
      depsOfOptionalPlugins = lib.subtractLists opt (findDependenciesRecursively opt);
      startWithDeps = findDependenciesRecursively start;
      allPlugins = lib.unique (startWithDeps ++ depsOfOptionalPlugins);
      python3Env = python3.withPackages (ps:
        lib.flatten (builtins.map (plugin: (plugin.python3Dependencies or (_: [])) ps) allPlugins)
      );
    in
      [ "mkdir -p $out/pack/${packageName}/start" ]
      # To avoid confusion, even dependencies of optional plugins are added
      # to `start` (except if they are explicitly listed as optional plugins).
      ++ (builtins.map (x: link x packageName "start") allPlugins)
      ++ ["mkdir -p $out/pack/${packageName}/opt"]
      ++ (builtins.map (x: link x packageName "opt") opt)
      # Assemble all python3 dependencies into a single `site-packages` to avoid doing recursive dependency collection
      # for each plugin.
      # This directory is only for python import search path, and will not slow down the startup time.
      ++ [
        "mkdir -p $out/pack/${packageName}/start/__python3_dependencies"
        "ln -s ${python3Env}/${python3Env.sitePackages} $out/pack/${packageName}/start/__python3_dependencies/python3"
      ];
  in
      stdenv.mkDerivation {
        name = "vim-pack-dir";
        src = ./.;
        installPhase = lib.concatStringsSep "\n" (lib.flatten (lib.mapAttrsToList packageLinks packages));
        preferLocalBuild = true;
    };

  nativeImpl = packages:
  ''
    set packpath^=${packDir packages}
    set runtimepath^=${packDir packages}
  '';

  /* Generates a vimrc string

    packages is an attrset with {name: { start = [ vim derivations ]; opt = [ vim derivations ]; }
    Example:
      vimrcContent {

        packages = { home-manager = { start = [vimPlugins.vim-fugitive]; opt = [];};
        beforePlugins = '';
        customRC = ''let mapleader = " "'';

      };
   */
  vimrcContent = {
    packages ? null,
    vam ? null,
    pathogen ? null,
    plug ? null,
    beforePlugins ? ''
      " configuration generated by NIX
      set nocompatible
    '',
    customRC ? null
  }:

    let
      /* pathogen mostly can set &rtp at startup time. Its used very commonly.
      */
      pathogenImpl = let
        knownPlugins = pathogen.knownPlugins or vimPlugins;

        plugins = findDependenciesRecursively (map (pluginToDrv knownPlugins) pathogen.pluginNames);

        pluginsEnv = buildEnv {
          name = "pathogen-plugin-env";
          paths = map (x: "${x}/${rtpPath}") plugins;
        };
      in
      ''
        let &rtp.=(empty(&rtp)?"":',')."${vimPlugins.vim-pathogen.rtp}"
        execute pathogen#infect('${pluginsEnv}/{}')

        filetype indent plugin on | syn on
      '';

      /* vim-plug is an extremely popular vim plugin manager.
      */
      plugImpl =
      (''
        source ${vimPlugins.vim-plug.rtp}/plug.vim
        silent! call plug#begin('/dev/null')

        '' + (lib.concatMapStringsSep "\n" (pkg: "Plug '${pkg.rtp}'") plug.plugins) + ''

        call plug#end()
      '');

      /*
       vim-addon-manager = VAM

       * maps names to plugin location

       * manipulates &rtp at startup time
         or when Vim has been running for a while

       * can activate plugins laziy (eg when loading a specific filetype)

       * knows about vim plugin dependencies (addon-info.json files)

       * still is minimalistic (only loads one file), the "check out" code it also
         has only gets loaded when a plugin is requested which is not found on disk
         yet

      */
      vamImpl = lib.optionalString (vam != null)
      (let
        knownPlugins = vam.knownPlugins or vimPlugins;

        # plugins specified by the user
        specifiedPlugins = map (pluginToDrv knownPlugins) (lib.concatMap vamDictToNames vam.pluginDictionaries);
        # plugins with dependencies
        plugins = findDependenciesRecursively specifiedPlugins;

        # Convert scalars, lists, and attrs, to VimL equivalents
        toVimL = x:
          if builtins.isString x then "'${lib.replaceStrings [ "\n" "'" ] [ "\n\\ " "''" ] x}'"
          else if builtins.isAttrs x && builtins ? out then toVimL x # a derivation
          else if builtins.isAttrs x then "{${lib.concatStringsSep ", " (lib.mapAttrsToList (n: v: "${toVimL n}: ${toVimL v}") x)}}"
          else if builtins.isList x then "[${lib.concatMapStringsSep ", " toVimL x}]"
          else if builtins.isInt x || builtins.isFloat x then builtins.toString x
          else if builtins.isBool x then (if x then "1" else "0")
          else throw "turning ${lib.generators.toPretty {} x} into a VimL thing not implemented yet";

      in assert builtins.hasAttr "vim-addon-manager" knownPlugins;
      ''
        filetype indent plugin on | syn on

        let g:nix_plugin_locations = {}
        ${lib.concatMapStrings (plugin: ''
          let g:nix_plugin_locations['${plugin.pname}'] = "${plugin.rtp}"
        '') plugins}
        let g:nix_plugin_locations['vim-addon-manager'] = "${knownPlugins.vim-addon-manager.rtp}"

        let g:vim_addon_manager = {}

        if exists('g:nix_plugin_locations')
          " nix managed config

          " override default function making VAM aware of plugin locations:
          fun! NixPluginLocation(name)
            let path = get(g:nix_plugin_locations, a:name, "")
            return path == "" ? vam#DefaultPluginDirFromName(a:name) : path
          endfun
          let g:vim_addon_manager.plugin_dir_by_name = 'NixPluginLocation'
          " tell Vim about VAM:
          let &rtp.=(empty(&rtp)?"":','). g:nix_plugin_locations['vim-addon-manager']
        else
          " standalone config

          let &rtp.=(empty(&rtp)?"":',').c.plugin_root_dir.'/vim-addon-manager'
          if !isdirectory(c.plugin_root_dir.'/vim-addon-manager/autoload')
            " checkout VAM
            execute '!git clone --depth=1 https://github.com/MarcWeber/vim-addon-manager '
                \       shellescape(c.plugin_root_dir.'/vim-addon-manager', 1)
          endif
        endif

        " tell vam which plugins to load, and when:
        let l = []
        ${lib.concatMapStrings (p: "call add(l, ${toVimL p})\n") vam.pluginDictionaries}
        call vam#Scripts(l, {})
      '');

      entries = [
        beforePlugins
        vamImpl
      ]
      ++ lib.optional (packages != null && packages != []) (nativeImpl packages)
      ++ lib.optional (pathogen != null) pathogenImpl
      ++ lib.optional (plug != null) plugImpl
      ++ [ customRC ];

    in
      lib.concatStringsSep "\n" (lib.filter (x: x != null && x != "") entries);

  vimrcFile = settings: writeText "vimrc" (vimrcContent settings);

in

rec {
  inherit vimrcFile;
  inherit vimrcContent;
  inherit packDir;

  # shell script with custom name passing [-u vimrc] [-U gvimrc] to vim
  vimWithRC = {
    vimExecutable,
    gvimExecutable,
    vimManPages,
    wrapManual,
    wrapGui,
    name ? "vim",
    vimrcFile ? null,
    gvimrcFile ? null,
    vimExecutableName,
    gvimExecutableName,
  }:
    let
      rcOption = o: file: lib.optionalString (file != null) "-${o} ${file}";
      vimWrapperScript = writeScriptBin vimExecutableName ''
        #!${runtimeShell}
        exec ${vimExecutable} ${rcOption "u" vimrcFile} ${rcOption "U" gvimrcFile} "$@"
      '';
      gvimWrapperScript = writeScriptBin gvimExecutableName ''
        #!${stdenv.shell}
        exec ${gvimExecutable} ${rcOption "u" vimrcFile} ${rcOption "U" gvimrcFile} "$@"
      '';
    in
      buildEnv {
        inherit name;
        paths = [
          vimWrapperScript
        ] ++ lib.optional wrapGui gvimWrapperScript
          ++ lib.optional wrapManual vimManPages
        ;
      };

  # add a customize option to a vim derivation
  makeCustomizable = vim: vim // {
    customize = {
      name,
      vimrcConfig,
      wrapManual ? true,
      wrapGui ? false,
      vimExecutableName ? name,
      gvimExecutableName ? (lib.concatStrings [ "g" name ]),
    }: vimWithRC {
      vimExecutable = "${vim}/bin/vim";
      gvimExecutable = "${vim}/bin/gvim";
      inherit name wrapManual wrapGui vimExecutableName gvimExecutableName;
      vimrcFile = vimrcFile vimrcConfig;
      vimManPages = buildEnv {
        name = "vim-doc";
        paths = [ vim ];
        pathsToLink = [ "/share/man" ];
      };
    };

    override = f: makeCustomizable (vim.override f);
    overrideAttrs = f: makeCustomizable (vim.overrideAttrs f);
  };

  pluginnames2Nix = {name, namefiles} : vim_configurable.customize {
    inherit name;
    vimrcConfig.vam.knownPlugins = vimPlugins;
    vimrcConfig.vam.pluginDictionaries = ["vim2nix"];
    vimrcConfig.customRC = ''
      " Yes - this is impure and will create the cache file and checkout vim-pi
      " into ~/.vim/vim-addons
      let g:vim_addon_manager.plugin_root_dir = "/tmp/vim2nix-".$USER
      if !isdirectory(g:vim_addon_manager.plugin_root_dir)
        call mkdir(g:vim_addon_manager.plugin_root_dir)
      else
        echom repeat("=", 80)
        echom "WARNING: reusing cache directory :".g:vim_addon_manager.plugin_root_dir
        echom repeat("=", 80)
      endif
      let opts = {}
      let opts.nix_prefetch_git = "${nix-prefetch-git}/bin/nix-prefetch-git"
      let opts.nix_prefetch_hg  = "${nix-prefetch-hg}/bin/nix-prefetch-hg"
      let opts.cache_file = g:vim_addon_manager.plugin_root_dir.'/cache'
      let opts.plugin_dictionaries = []
      ${lib.concatMapStrings (file: "let opts.plugin_dictionaries += map(readfile(\"${file}\"), 'eval(v:val)')\n") namefiles }

      " uncomment for debugging failures
      " let opts.try_catch = 0

      " add more files
      " let opts.plugin_dictionaries += map(.. other file )
      call nix#ExportPluginsForNix(opts)
    '';
  };

  vimGenDocHook = callPackage ({ vim }:
    makeSetupHook {
      name = "vim-gen-doc-hook";
      deps = [ vim ];
      substitutions = {
        vimBinary = "${vim}/bin/vim";
        inherit rtpPath;
      };
    } ./vim-gen-doc-hook.sh) {};

  inherit (import ./build-vim-plugin.nix { inherit lib stdenv rtpPath vim vimGenDocHook; })
    buildVimPlugin buildVimPluginFrom2Nix;

  # used to figure out which python dependencies etc. neovim needs
  requiredPlugins = {
    packages ? {},
    givenKnownPlugins ? null,
    vam ? null,
    pathogen ? null,
    plug ? null, ...
  }:
    let
      # This is probably overcomplicated, but I don't understand this well enough to know what's necessary.
      knownPlugins = if givenKnownPlugins != null then givenKnownPlugins else
                     if vam != null && vam ? knownPlugins then vam.knownPlugins else
                     if pathogen != null && pathogen ? knownPlugins then pathogen.knownPlugins else
                     vimPlugins;
      pathogenPlugins = findDependenciesRecursively (map (pluginToDrv knownPlugins) pathogen.pluginNames);
      vamPlugins = findDependenciesRecursively (map (pluginToDrv knownPlugins) (lib.concatMap vamDictToNames vam.pluginDictionaries));
      nonNativePlugins = (lib.optionals (pathogen != null) pathogenPlugins)
                      ++ (lib.optionals (vam != null) vamPlugins)
                      ++ (lib.optionals (plug != null) plug.plugins);
      nativePluginsConfigs = lib.attrsets.attrValues packages;
      nativePlugins = lib.concatMap ({start?[], opt?[], knownPlugins?vimPlugins}: start++opt) nativePluginsConfigs;
    in
      nativePlugins ++ nonNativePlugins;
}
