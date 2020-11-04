{ lib
, vimUtils
, nodejs
, neovim-unwrapped
, bundlerEnv
, ruby
, pythonPackages
, python3Packages
, writeText
, wrapNeovimUnstable
}:
let
  # returns everything needed for the caller to wrap its own neovim:
  # - the generated content of the future init.vim
  # - the arguments to wrap neovim with
  # The caller is responsible for writing the init.vim and adding it to the wrapped
  # arguments (["-u" writeText "init.vim" GENERATEDRC)]).
  # This makes it possible to write the config anywhere: on a per-project basis
  # .nvimrc or in $XDG_CONFIG_HOME/nvim/init.vim to avoid sideeffects.
  # Indeed, note that wrapping with `-u init.vim` has sideeffects like .nvimrc wont be loaded
  # anymore, $MYVIMRC wont be set etc
  makeNeovimConfig =
    {
    withPython2 ? false
    /* the function you would have passed to python.withPackages */
    , extraPython2Packages ? (_: [ ])
    , withPython3 ? true
    /* the function you would have passed to python3.withPackages */
    , extraPython3Packages ? (_: [ ])
    , withNodeJs ? false
    , withRuby ? true

    # same values as in vimUtils.vimrcContent
    , configure ? { }

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

      requiredPlugins = vimUtils.requiredPlugins configure;
      getDeps = attrname: map (plugin: plugin.${attrname} or (_: [ ]));

      pluginPython2Packages = getDeps "pythonDependencies" requiredPlugins;
      python2Env = pythonPackages.python.withPackages (ps:
        [ ps.pynvim ]
        ++ (extraPython2Packages ps)
        ++ (lib.concatMap (f: f ps) pluginPython2Packages));

      pluginPython3Packages = getDeps "python3Dependencies" requiredPlugins;
      python3Env = python3Packages.python.withPackages (ps:
        [ ps.pynvim ]
        ++ (extraPython3Packages ps)
        ++ (lib.concatMap (f: f ps) pluginPython3Packages));


      # Mapping a boolean argument to a key that tells us whether to add or not to
      # add to nvim's 'embedded rc' this:
      #    let g:<key>_host_prog=$out/bin/nvim-<key>
      # Or this:
      #    let g:loaded_${prog}_provider=1
      # While the latter tells nvim that this provider is not available
      hostprog_check_table = {
        node = withNodeJs;
        python = withPython2;
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

          flags = lib.concatLists (lib.mapAttrsToList (
              prog: withProg: [
                "--cmd" (genProviderSettings prog withProg)
              ]
            )
            hostprog_check_table);
        in
        [
          "--argv0" "$0" "--add-flags" (lib.escapeShellArgs flags)
        ] ++ lib.optionals withRuby [
          "--set" "GEM_HOME" "${rubyEnv}/${rubyEnv.ruby.gemPath}"
        ] ++ lib.optionals (binPath != "") [
          "--suffix" "PATH" ":" binPath
        ];

      manifestRc = vimUtils.vimrcContent (configure // { customRC = ""; });
      neovimRcContent = vimUtils.vimrcContent configure;
    in
    args // {
      wrapperArgs = makeWrapperArgs;
      inherit neovimRcContent;
      inherit manifestRc;
      inherit python2Env;
      inherit python3Env;
      inherit withNodeJs;
    } // lib.optionalAttrs withRuby {
      inherit rubyEnv;
    };

    genProviderSettings = prog: withProg:
      if withProg then
        "let g:${prog}_host_prog='${placeholder "out"}/bin/nvim-${prog}'"
      else
        "let g:loaded_${prog}_provider=1"
    ;

  # to keep backwards compatibility
  legacyWrapper = neovim: {
    extraMakeWrapperArgs ? ""
    , withPython ? true
    /* the function you would have passed to python.withPackages */
    , extraPythonPackages ? (_: [])
    /* the function you would have passed to python.withPackages */
    , withPython3 ? true,  extraPython3Packages ? (_: [])
    , withNodeJs ? false
    , withRuby ? true
    , vimAlias ? false
    , viAlias ? false
    , configure ? {}
  }:
    let
      /* for compatibility with passing extraPythonPackages as a list; added 2018-07-11 */
      compatFun = funOrList: (if builtins.isList funOrList then
        (_: lib.warn "passing a list as extraPythonPackages to the neovim wrapper is deprecated, pass a function as to python.withPackages instead" funOrList)
      else funOrList);

      res = makeNeovimConfig {
        withPython2 = withPython;
        extraPythonPackages = compatFun extraPythonPackages;
        inherit withPython3;
        extraPython3Packages = compatFun extraPython3Packages;
        inherit withNodeJs withRuby viAlias vimAlias;
        inherit configure;
      };
    in
    wrapNeovimUnstable neovim (res // {
      wrapperArgs = lib.escapeShellArgs (
        res.wrapperArgs ++ lib.optionals (configure != {}) [
          "--add-flags" "-u ${writeText "init.vim" res.neovimRcContent}"
        ]) + " " + extraMakeWrapperArgs
      ;
  });
in
{
  inherit makeNeovimConfig;
  inherit legacyWrapper;
}
