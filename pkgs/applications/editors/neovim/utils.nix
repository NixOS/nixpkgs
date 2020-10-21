{ lib
, vimUtils
, nodejs
, neovim-unwrapped
, bundlerEnv
, ruby
, pythonPackages
, python3Packages
, writeText
, wrapNeovim2
}:
let
  # vimWithRC pass it args
  # need a function that generates wrapperArgs + customRC and then one can create its own package from that.
  # should let the user write its own file.
  makeNeovimConfig =
    {
    withPython ? false
    , extraPythonPackages ? (_: [ ]) /* the function you would have passed to python.withPackages */
    , withPython3 ? true
    , extraPython3Packages ? (_: [ ]) /* the function you would have passed to python.withPackages */
    , withNodeJs ? false
    , withRuby ? true
    , configure ? { }

    # whether to wrap the Rc file
    # dont use it, should be discarded as we update neovim wrapper
    , wrapRc ? true

    # for forward compability, when adding features
    , ...
    }:
    let
      rubyEnv = bundlerEnv {
        name = "neovim-ruby-env";
        gemdir = ./ruby_provider;
        postBuild = ''
          ln -sf ${ruby}/bin/* $out/bin
        '';
      };

      /* for compatibility with passing extraPythonPackages as a list; added 2018-07-11 */
      compatFun = funOrList: (if builtins.isList funOrList then
        (_: lib.warn "passing a list as extraPythonPackages to the neovim wrapper is deprecated, pass a function as to python.withPackages instead" funOrList)
      else funOrList);
      extraPythonPackagesFun = compatFun extraPythonPackages;
      extraPython3PackagesFun = compatFun extraPython3Packages;

      requiredPlugins = vimUtils.requiredPlugins configure;
      getDeps = attrname: map (plugin: plugin.${attrname} or (_: [ ]));

      pluginPythonPackages = getDeps "pythonDependencies" requiredPlugins;
      pythonEnv = pythonPackages.python.withPackages (ps:
        [ ps.pynvim ]
        ++ (extraPythonPackagesFun ps)
        ++ (lib.concatMap (f: f ps) pluginPythonPackages));

      pluginPython3Packages = getDeps "python3Dependencies" requiredPlugins;
      python3Env = python3Packages.python.withPackages (ps:
        [ ps.pynvim ]
        ++ (extraPython3PackagesFun ps)
        ++ (lib.concatMap (f: f ps) pluginPython3Packages));

      binPath = lib.makeBinPath (lib.optionals withRuby [ rubyEnv ] ++ lib.optionals withNodeJs [ nodejs ]);

      # Mapping a boolean argument to a key that tells us whether to add or not to
      # add to nvim's 'embedded rc' this:
      #    let g:<key>_host_prog=$out/bin/nvim-<key>
      # Or this:
      #    let g:loaded_${prog}_provider=1
      # While the later tells nvim that this provider is not available
      hostprog_check_table = {
        node = withNodeJs;
        python = withPython;
        python3 = withPython3;
        ruby = withRuby;
      };
      ## Here we calculate all of the arguments to the 1st call of `makeWrapper`
      # We start with the executable itself NOTE we call this variable "initial"
      # because if configure != {} we need to call makeWrapper twice, in order to
      # avoid double wrapping, see comment near finalMakeWrapperArgs
      initialMakeWrapperArgs =
        let
          flags = lib.concatLists (lib.mapAttrsToList
            (
              prog:
              withProg:
              [
                "--cmd"
                (if withProg then
                  "let g:${prog}_host_prog='${placeholder "out"}/bin/nvim-${prog}'"
                else
                  "let g:loaded_${prog}_provider=1"
                )
              ]
            )
            hostprog_check_table);
        in
        [
          "--argv0"
          "$0"
          "--add-flags"
          (lib.escapeShellArgs flags)
        ] ++ lib.optionals withRuby [
          "--set"
          "GEM_HOME"
          "${rubyEnv}/${rubyEnv.ruby.gemPath}"
        ] ++ lib.optionals (binPath != "") [
          "--suffix"
          "PATH"
          ":"
          binPath
        ];
      # If configure != {}, we can't generate the rplugin.vim file with e.g
      # NVIM_SYSTEM_RPLUGIN_MANIFEST *and* NVIM_RPLUGIN_MANIFEST env vars set in
      # the wrapper. That's why only when configure != {} (tested both here and
      # when postBuild is evaluated), we call makeWrapper once to generate a
      # wrapper with most arguments we need, excluding those that cause problems to
      # generate rplugin.vim, but still required for the final wrapper.
      finalMakeWrapperArgs = initialMakeWrapperArgs
        # this relies on a patched neovim, see
        # https://github.com/neovim/neovim/issues/9413
        ++ lib.optionals (configure != { }) [
        "--set"
        "NVIM_SYSTEM_RPLUGIN_MANIFEST"
        "${placeholder "out"}/rplugin.vim"
      ];

      manifestRc = vimUtils.vimrcContent (configure // { customRC = ""; });
      neovimRcContent = vimUtils.vimrcContent configure;
    in
    {
      wrapperArgs = finalMakeWrapperArgs;
      neovimRc = neovimRcContent;
      inherit manifestRc;
      inherit rubyEnv;
      inherit pythonEnv;
      inherit python3Env;
    };


  # to keep backwards compatibility
  legacyWrapper = neovim: {
    extraMakeWrapperArgs ? []
    , withPython ? true
    /* the function you would have passed to python.withPackages */
    ,  extraPythonPackages ? (_: [])
    /* the function you would have passed to python.withPackages */
    , withPython3 ? true,  extraPython3Packages ? (_: [])
    , withNodeJs ? false
    , withRuby ? true
    , vimAlias ? false
    , viAlias ? false
    , configure ? {}
  }:
    let
      res = makeNeovimConfig {
        inherit withPython extraPythonPackages;
        inherit withPython3 extraPython3Packages;
        inherit withNodeJs withRuby;

        inherit configure;
      };
    in
    wrapNeovim2 neovim (res // {
      wrapperArgs = res.wrapperArgs ++ [
        "--add-flags" "-u ${writeText "init.vim" res.neovimRcContent}"
      ]
      ++ (if builtins.isList extraMakeWrapperArgs then extraMakeWrapperArgs
      else lib.warn "Passing a string as extraMakeWrapperArgs to the neovim wrapper is
        deprecated, please use a list instead")
      ;
  });
in
{
  inherit makeNeovimConfig;
  inherit legacyWrapper;
}
