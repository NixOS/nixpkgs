# tests available at pkgs/test/vim
{ lib, stdenv, vim, vimPlugins, vim_configurable, buildEnv, writeText
, runCommand, makeWrapper
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
    name = "vim-with-plugins"; # optional

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


CREATING DERIVATIONS AUTOMATICALLY BY PLUGIN NAME
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
      ++ (builtins.map (x: linkVimlPlugin x packageName "start") allPlugins)
      ++ ["mkdir -p $out/pack/${packageName}/opt"]
      ++ (builtins.map (x: linkVimlPlugin x packageName "opt") opt)
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
      /* pathogen mostly can set &rtp at startup time. Deprecated.
      */
      pathogenImpl = let
        knownPlugins = pathogen.knownPlugins or vimPlugins;

        plugins = findDependenciesRecursively (map (pluginToDrv knownPlugins) pathogen.pluginNames);

        pathogenPackages.pathogen = {
          start = plugins;
        };
      in
        nativeImpl pathogenPackages;

      /* vim-plug is an extremely popular vim plugin manager.
      */
      plugImpl =
      ''
        source ${vimPlugins.vim-plug.rtp}/plug.vim
        silent! call plug#begin('/dev/null')

        '' + (lib.concatMapStringsSep "\n" (pkg: "Plug '${pkg.rtp}'") plug.plugins) + ''

        call plug#end()
      '';

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
      vamImpl =
      let
        knownPlugins = vam.knownPlugins or vimPlugins;

        # plugins specified by the user
        specifiedPlugins = map (pluginToDrv knownPlugins) (lib.concatMap vamDictToNames vam.pluginDictionaries);
        # plugins with dependencies
        plugins = findDependenciesRecursively specifiedPlugins;
        vamPackages.vam =  {
          start = plugins;
        };
      in
        nativeImpl vamPackages;

      entries = [
        beforePlugins
      ]
      ++ lib.optional (vam != null) (lib.warn "'vam' attribute is deprecated. Use 'packages' instead in your vim configuration" vamImpl)
      ++ lib.optional (packages != null && packages != []) (nativeImpl packages)
      ++ lib.optional (pathogen != null) (lib.warn "'pathogen' attribute is deprecated. Use 'packages' instead in your vim configuration" pathogenImpl)
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

  makeCustomizable = let
    mkVimrcFile = vimrcFile; # avoid conflict with argument name
  in vim: vim // {
    # Returns a customized vim that uses the specified vimrc configuration.
    customize =
      { # The name of the derivation.
        name ? "vim"
      , # A shell word used to specify the names of the customized executables.
        # The shell variable $exe can be used to refer to the wrapped executable's name.
        # Examples: "my-$exe", "$exe-with-plugins", "\${exe/vim/v1m}"
        executableName ?
          if lib.hasInfix "vim" name then
            lib.replaceStrings [ "vim" ] [ "$exe" ] name
          else
            "\${exe/vim/${lib.escapeShellArg name}}"
      , # A custom vimrc configuration, treated as an argument to vimrcContent (see the documentation in this file).
        vimrcConfig ? null
      , # A custom vimrc file.
        vimrcFile ? null
      , # A custom gvimrc file.
        gvimrcFile ? null
      , # If set to true, return the *vim wrappers only.
        # If set to false, overlay the wrappers on top of the original vim derivation.
        # This ensures that things like man pages and .desktop files are available.
        standalone ? name != "vim" && wrapManual != true

      , # deprecated arguments (TODO: remove eventually)
        wrapManual ? null, wrapGui ? null, vimExecutableName ? null, gvimExecutableName ? null,
      }:
      lib.warnIf (wrapManual != null) ''
        vim.customize: wrapManual is deprecated: the manual is now included by default if `name == "vim"`.
        ${if wrapManual == true && name != "vim" then "Set `standalone = false` to include the manual."
        else if wrapManual == false && name == "vim" then "Set `standalone = true` to get the *vim wrappers only."
        else ""}''
      lib.warnIf (wrapGui != null)
        "vim.customize: wrapGui is deprecated: gvim is now automatically included if present"
      lib.throwIfNot (vimExecutableName == null && gvimExecutableName == null)
        "vim.customize: (g)vimExecutableName is deprecated: use executableName instead (see source code for examples)"
      (let
        vimrc =
          if vimrcFile != null then vimrcFile
          else if vimrcConfig != null then mkVimrcFile vimrcConfig
          else throw "at least one of vimrcConfig and vimrcFile must be specified";
        bin = runCommand "${name}-bin" { buildInputs = [ makeWrapper ]; } ''
          vimrc=${lib.escapeShellArg vimrc}
          gvimrc=${if gvimrcFile != null then lib.escapeShellArg gvimrcFile else ""}

          mkdir -p "$out/bin"
          for exe in ${
            if standalone then "{,g,r,rg,e}vim {,g}vimdiff vi"
            else "{,g,r,rg,e}{vim,view} {,g}vimdiff ex vi"
          }; do
            if [[ -e ${vim}/bin/$exe ]]; then
              dest="$out/bin/${executableName}"
              if [[ -e $dest ]]; then
                echo "ambiguous executableName: ''${dest##*/} already exists"
                continue
              fi
              makeWrapper ${vim}/bin/"$exe" "$dest" \
                --add-flags "-u ''${vimrc@Q} ''${gvimrc:+-U ''${gvimrc@Q}}"
            fi
          done
        '';
      in if standalone then bin else
        buildEnv {
          inherit name;
          paths = [ (lib.lowPrio vim) bin ];
        });

    override = f: makeCustomizable (vim.override f);
    overrideAttrs = f: makeCustomizable (vim.overrideAttrs f);
  };

  vimWithRC = throw "vimWithRC was removed, please use vim.customize instead";

  vimGenDocHook = callPackage ({ vim }:
    makeSetupHook {
      name = "vim-gen-doc-hook";
      deps = [ vim ];
      substitutions = {
        vimBinary = "${vim}/bin/vim";
        inherit rtpPath;
      };
    } ./vim-gen-doc-hook.sh) {};

  vimCommandCheckHook = callPackage ({ neovim-unwrapped }:
    makeSetupHook {
      name = "vim-command-check-hook";
      deps = [ neovim-unwrapped ];
      substitutions = {
        vimBinary = "${neovim-unwrapped}/bin/nvim";
        inherit rtpPath;
      };
    } ./vim-command-check-hook.sh) {};

  neovimRequireCheckHook = callPackage ({ neovim-unwrapped }:
    makeSetupHook {
      name = "neovim-require-check-hook";
      deps = [ neovim-unwrapped ];
      substitutions = {
        nvimBinary = "${neovim-unwrapped}/bin/nvim";
        inherit rtpPath;
      };
    } ./neovim-require-check-hook.sh) {};

  inherit (import ./build-vim-plugin.nix {
    inherit lib stdenv rtpPath vim vimGenDocHook
      toVimPlugin vimCommandCheckHook neovimRequireCheckHook;
  }) buildVimPlugin buildVimPluginFrom2Nix;


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

  toVimPlugin = drv:
    drv.overrideAttrs(oldAttrs: {
      # dont move the "doc" folder since vim expects it
      forceShare = [ "man" "info" ];

      nativeBuildInputs = oldAttrs.nativeBuildInputs or []
      ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
        vimCommandCheckHook vimGenDocHook
        # many neovim plugins keep using buildVimPlugin
        neovimRequireCheckHook
      ];

      passthru = (oldAttrs.passthru or {}) // {
        vimPlugin = true;
      };
    });
}
