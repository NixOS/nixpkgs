{ stdenv, symlinkJoin, lib, makeWrapper
, vimUtils
, bundlerEnv, ruby
, nodejs
, nodePackages
, pythonPackages
, python3Packages
}:
with stdenv.lib;

neovim:

let
  wrapper = {
      extraMakeWrapperArgs ? ""
    , withPython ? true,  extraPythonPackages ? (_: []) /* the function you would have passed to python.withPackages */
    , withPython3 ? true,  extraPython3Packages ? (_: []) /* the function you would have passed to python.withPackages */
    , withNodeJs? false
    , withRuby ? true
    , vimAlias ? false
    , viAlias ? false
    , configure ? {}
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
  getDeps = attrname: map (plugin: plugin.${attrname} or (_:[]));

  pluginPythonPackages = getDeps "pythonDependencies" requiredPlugins;
  pythonEnv = pythonPackages.python.withPackages(ps:
        [ ps.pynvim ]
        ++ (extraPythonPackagesFun ps)
        ++ (concatMap (f: f ps) pluginPythonPackages));

  pluginPython3Packages = getDeps "python3Dependencies" requiredPlugins;
  python3Env = python3Packages.python.withPackages (ps:
        [ ps.pynvim ]
        ++ (extraPython3PackagesFun ps)
        ++ (concatMap (f: f ps) pluginPython3Packages));

  binPath = makeBinPath (optionals withRuby [rubyEnv] ++ optionals withNodeJs [nodejs]);

  # Mapping a boolean argument to a key that tells us whether to add or not to
  # add to nvim's 'embedded rc' this:
  #
  #    let g:<key>_host_prog=$out/bin/nvim-<key>
  #
  # Or this:
  #
  #    let g:loaded_${prog}_provider=1
  #
  # While the later tells nvim that this provider is not available
  #
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
      flags = lib.concatLists (lib.mapAttrsToList (
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
      ) hostprog_check_table);
    in [
      "${neovim}/bin/nvim" "${placeholder "out"}/bin/nvim"
      "--argv0" "$0"
      "--add-flags" (lib.escapeShellArgs flags)
    ] ++ lib.optionals withRuby [
      "--set" "GEM_HOME" "${rubyEnv}/${rubyEnv.ruby.gemPath}"
    ] ++ lib.optionals (binPath != "") [
      "--suffix" "PATH" ":" binPath
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
    ++ lib.optionals (configure != {}) [
      "--set" "NVIM_SYSTEM_RPLUGIN_MANIFEST" "${placeholder "out"}/rplugin.vim"
      "--add-flags" "-u ${vimUtils.vimrcFile configure}"
    ]
  ;
  in
  symlinkJoin {
      name = "neovim-${stdenv.lib.getVersion neovim}";
      # Remove the symlinks created by symlinkJoin which we need to perform
      # extra actions upon
      postBuild = ''
        rm $out/bin/nvim
        makeWrapper ${lib.escapeShellArgs initialMakeWrapperArgs} ${extraMakeWrapperArgs}
      ''
      + lib.optionalString stdenv.isLinux ''
        rm $out/share/applications/nvim.desktop
        substitute ${neovim}/share/applications/nvim.desktop $out/share/applications/nvim.desktop \
          --replace 'TryExec=nvim' "TryExec=$out/bin/nvim" \
          --replace 'Name=Neovim' 'Name=WrappedNeovim'
      ''
      + optionalString withPython ''
        makeWrapper ${pythonEnv}/bin/python $out/bin/nvim-python --unset PYTHONPATH
      ''
      + optionalString withPython3 ''
        makeWrapper ${python3Env}/bin/python3 $out/bin/nvim-python3 --unset PYTHONPATH
      ''
      + optionalString withRuby ''
        ln -s ${rubyEnv}/bin/neovim-ruby-host $out/bin/nvim-ruby
      ''
      + optionalString withNodeJs ''
        ln -s ${nodePackages.neovim}/bin/neovim-node $out/bin/nvim-node
      ''
      + optionalString vimAlias ''
        ln -s $out/bin/nvim $out/bin/vim
      ''
      + optionalString viAlias ''
        ln -s $out/bin/nvim $out/bin/vi
      ''
      + optionalString (configure != {}) ''
        echo "Generating remote plugin manifest"
        export NVIM_RPLUGIN_MANIFEST=$out/rplugin.vim
        # Some plugins assume that the home directory is accessible for
        # initializing caches, temporary files, etc. Even if the plugin isn't
        # actively used, it may throw an error as soon as Neovim is launched
        # (e.g., inside an autoload script), causing manifest generation to
        # fail. Therefore, let's create a fake home directory before generating
        # the manifest, just to satisfy the needs of these plugins.
        #
        # See https://github.com/Yggdroot/LeaderF/blob/v1.21/autoload/lfMru.vim#L10
        # for an example of this behavior.
        export HOME="$(mktemp -d)"
        # Launch neovim with a vimrc file containing only the generated plugin
        # code. Pass various flags to disable temp file generation
        # (swap/viminfo) and redirect errors to stderr.
        # Only display the log on error since it will contain a few normally
        # irrelevant messages.
        if ! $out/bin/nvim \
          -u ${vimUtils.vimrcFile (configure // { customRC = ""; })} \
          -i NONE -n \
          -E -V1rplugins.log -s \
          +UpdateRemotePlugins +quit! > outfile 2>&1; then
          cat outfile
          echo -e "\nGenerating rplugin.vim failed!"
          exit 1
        fi
        makeWrapper ${lib.escapeShellArgs finalMakeWrapperArgs} ${extraMakeWrapperArgs}
      '';

    paths = [ neovim ];

    preferLocalBuild = true;

    buildInputs = [makeWrapper];
    passthru = { unwrapped = neovim; };

    meta = neovim.meta // {
      # To prevent builds on hydra
      hydraPlatforms = [];
      # prefer wrapper over the package
      priority = (neovim.meta.priority or 0) - 1;
    };
  };
in
  lib.makeOverridable wrapper
