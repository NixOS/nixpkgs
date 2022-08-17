{ lib
, buildLuarocksPackage
, callPackage
, vimUtils
, nodejs
, neovim-unwrapped
, bundlerEnv
, ruby
, python3Packages
, writeText
, wrapNeovimUnstable
}:
let
   /* returns everything needed for the caller to wrap its own neovim:
   - the generated content of the future init.vim
   - the arguments to wrap neovim with
   The caller is responsible for writing the init.vim and adding it to the wrapped
   arguments (["-u" writeText "init.vim" GENERATEDRC)]).
   This makes it possible to write the config anywhere: on a per-project basis
   .nvimrc or in $XDG_CONFIG_HOME/nvim/init.vim to avoid sideeffects.
   Indeed, note that wrapping with `-u init.vim` has sideeffects like .nvimrc wont be loaded
   anymore, $MYVIMRC wont be set etc
   */
  makeNeovimConfig =
    { withPython3 ? true
    /* the function you would have passed to python3.withPackages */
    , extraPython3Packages ? (_: [ ])
    , withNodeJs ? false
    , withRuby ? true
    /* the function you would have passed to lua.withPackages */
    , extraLuaPackages ? (_: [ ])

    # expects a list of plugin configuration
    # expects { plugin=far-vim; config = "let g:far#source='rg'"; optional = false; }
    , plugins ? []
    # custom viml config appended after plugin-specific config
    , customRC ? ""

    # for forward compability, when adding new environments, haskell etc.
    , ...
    }@args:
    let
      rubyEnv = bundlerEnv {
        name = "neovim-ruby-env";
        gemdir = ./ruby_provider;
        postBuild = ''
          ln -sf ${ruby}/bin/* $out/bin
        '';
      };

      # transform all plugins into an attrset
      # { optional = bool; plugin = package; }
      pluginsNormalized = let
        defaultPlugin = {
          plugin = null;
          config = null;
          optional = false;
        };
      in
        map (x: defaultPlugin // (if (x ? plugin) then x else { plugin = x; })) plugins;

      pluginRC = lib.foldl (acc: p: if p.config != null then acc ++ [p.config] else acc) []  pluginsNormalized;

      pluginsPartitioned = lib.partition (x: x.optional == true) pluginsNormalized;
      requiredPlugins = vimUtils.requiredPluginsForPackage myVimPackage;
      getDeps = attrname: map (plugin: plugin.${attrname} or (_: [ ]));
      myVimPackage = {
            start = map (x: x.plugin) pluginsPartitioned.wrong;
            opt = map (x: x.plugin) pluginsPartitioned.right;
      };

      pluginPython3Packages = getDeps "python3Dependencies" requiredPlugins;
      python3Env = python3Packages.python.withPackages (ps:
        [ ps.pynvim ]
        ++ (extraPython3Packages ps)
        ++ (lib.concatMap (f: f ps) pluginPython3Packages));

      luaEnv = neovim-unwrapped.lua.withPackages(extraLuaPackages);

      # Mapping a boolean argument to a key that tells us whether to add or not to
      # add to nvim's 'embedded rc' this:
      #    let g:<key>_host_prog=$out/bin/nvim-<key>
      # Or this:
      #    let g:loaded_${prog}_provider=0
      # While the latter tells nvim that this provider is not available
      hostprog_check_table = {
        node = withNodeJs;
        python = false;
        python3 = withPython3;
        ruby = withRuby;
      };
      ## Here we calculate all of the arguments to the 1st call of `makeWrapper`
      # We start with the executable itself NOTE we call this variable "initial"
      # because if configure != {} we need to call makeWrapper twice, in order to
      # avoid double wrapping, see comment near finalMakeWrapperArgs
      makeWrapperArgs =
        let
          binPath = lib.makeBinPath (lib.optionals withRuby [ rubyEnv ] ++ lib.optionals withNodeJs [ nodejs ]);

          hostProviderViml = lib.mapAttrsToList genProviderSettings hostprog_check_table;

          # as expected by packdir
          packDirArgs.myNeovimPackages = myVimPackage;

          # vim accepts a limited number of commands so we join them all
          flags = [
            "--cmd" (lib.intersperse "|" hostProviderViml)
            "--cmd" "set packpath^=${vimUtils.packDir packDirArgs}"
            ];
        in
        [
          "--inherit-argv0" "--add-flags" (lib.escapeShellArgs flags)
        ] ++ lib.optionals withRuby [
          "--set" "GEM_HOME" "${rubyEnv}/${rubyEnv.ruby.gemPath}"
        ] ++ lib.optionals (binPath != "") [
          "--suffix" "PATH" ":" binPath
        ] ++ lib.optionals (luaEnv != null) [
          "--prefix" "LUA_PATH" ";" (neovim-unwrapped.lua.pkgs.lib.genLuaPathAbsStr luaEnv)
          "--prefix" "LUA_CPATH" ";" (neovim-unwrapped.lua.pkgs.lib.genLuaCPathAbsStr luaEnv)
        ];

      manifestRc = vimUtils.vimrcContent ({ customRC = ""; }) ;
      # we call vimrcContent without 'packages' to avoid the init.vim generation
      neovimRcContent = vimUtils.vimrcContent ({
        beforePlugins = "";
        customRC = lib.concatStringsSep "\n" (pluginRC ++ [customRC]);
        packages = null;
      });
    in

    builtins.removeAttrs args ["plugins"] // {
      wrapperArgs = makeWrapperArgs;
      inherit neovimRcContent;
      inherit manifestRc;
      inherit python3Env;
      inherit luaEnv;
      inherit withNodeJs;
    } // lib.optionalAttrs withRuby {
      inherit rubyEnv;
    };

    genProviderSettings = prog: withProg:
      if withProg then
        "let g:${prog}_host_prog='${placeholder "out"}/bin/nvim-${prog}'"
      else
        "let g:loaded_${prog}_provider=0"
    ;

  # to keep backwards compatibility for people using neovim.override
  legacyWrapper = neovim: {
    extraMakeWrapperArgs ? ""
    /* the function you would have passed to python.withPackages */
    , extraPythonPackages ? (_: [])
    /* the function you would have passed to python.withPackages */
    , withPython3 ? true,  extraPython3Packages ? (_: [])
    /* the function you would have passed to lua.withPackages */
    , extraLuaPackages ? (_: [])
    , withNodeJs ? false
    , withRuby ? true
    , vimAlias ? false
    , viAlias ? false
    , configure ? {}
    , extraName ? ""
  }:
    let

      # we convert from the old configure.format to
      plugins = if builtins.hasAttr "plug" configure then
          throw "The neovim legacy wrapper doesn't support configure.plug anymore, please setup your plugins via 'configure.packages' instead"
        else
          lib.flatten (lib.mapAttrsToList genPlugin (configure.packages or {}));
      genPlugin = packageName: {start ? [], opt?[]}:
        start ++ opt;

      res = makeNeovimConfig {
        inherit withPython3;
        inherit extraPython3Packages;
        inherit extraLuaPackages;
        inherit withNodeJs withRuby viAlias vimAlias;
        customRC = configure.customRC or "";
        inherit plugins;
        inherit extraName;
      };
    in
    wrapNeovimUnstable neovim (res // {
      wrapperArgs = lib.escapeShellArgs res.wrapperArgs + " " + extraMakeWrapperArgs;
      wrapRc = (configure != {});
  });
in
{
  inherit makeNeovimConfig;
  inherit legacyWrapper;

  buildNeovimPluginFrom2Nix = callPackage ./build-neovim-plugin.nix {
    inherit (vimUtils) buildVimPluginFrom2Nix toVimPlugin;
    inherit buildLuarocksPackage;
  };
}
