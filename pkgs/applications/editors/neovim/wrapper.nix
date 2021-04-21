{ stdenv, symlinkJoin, lib, makeWrapper
, writeText
, bundlerEnv, ruby
, nodejs
, nodePackages
, pythonPackages
, python3Packages
}:
with lib;

neovim:

let
  wrapper = {
      # should contain all args but the binary
      wrapperArgs ? ""
    , manifestRc ? null
    , withPython2 ? true, python2Env ? null
    , withPython3 ? true,  python3Env ? null
    , withNodeJs ? false
    , rubyEnv ? null
    , vimAlias ? false
    , viAlias ? false
    , ...
  }:
  let

  # If configure != {}, we can't generate the rplugin.vim file with e.g
  # NVIM_SYSTEM_RPLUGIN_MANIFEST *and* NVIM_RPLUGIN_MANIFEST env vars set in
  # the wrapper. That's why only when configure != {} (tested both here and
  # when postBuild is evaluated), we call makeWrapper once to generate a
  # wrapper with most arguments we need, excluding those that cause problems to
  # generate rplugin.vim, but still required for the final wrapper.
  finalMakeWrapperArgs =
    [ "${neovim}/bin/nvim" "${placeholder "out"}/bin/nvim" ] ++
      [ "--set" "NVIM_SYSTEM_RPLUGIN_MANIFEST" "${placeholder "out"}/rplugin.vim" ];
  in
  symlinkJoin {
      name = "neovim-${lib.getVersion neovim}";
      # Remove the symlinks created by symlinkJoin which we need to perform
      # extra actions upon
      postBuild = lib.optionalString stdenv.isLinux ''
        rm $out/share/applications/nvim.desktop
        substitute ${neovim}/share/applications/nvim.desktop $out/share/applications/nvim.desktop \
          --replace 'Name=Neovim' 'Name=WrappedNeovim'
      ''
      + optionalString withPython2 ''
        makeWrapper ${python2Env}/bin/python $out/bin/nvim-python --unset PYTHONPATH
      ''
      + optionalString withPython3 ''
        makeWrapper ${python3Env}/bin/python3 $out/bin/nvim-python3 --unset PYTHONPATH
      ''
      + optionalString (rubyEnv != null) ''
        ln -s ${rubyEnv}/bin/neovim-ruby-host $out/bin/nvim-ruby
      ''
      + optionalString withNodeJs ''
        ln -s ${nodePackages.neovim}/bin/neovim-node-host $out/bin/nvim-node
      ''
      + optionalString vimAlias ''
        ln -s $out/bin/nvim $out/bin/vim
      ''
      + optionalString viAlias ''
        ln -s $out/bin/nvim $out/bin/vi
      ''
      + optionalString (manifestRc != null) (let
        manifestWrapperArgs =
          [ "${neovim}/bin/nvim" "${placeholder "out"}/bin/nvim-wrapper" ];
      in ''
        echo "Generating remote plugin manifest"
        export NVIM_RPLUGIN_MANIFEST=$out/rplugin.vim
        makeWrapper ${lib.escapeShellArgs manifestWrapperArgs} ${wrapperArgs}

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
        if ! $out/bin/nvim-wrapper \
          -u ${writeText "manifest.vim" manifestRc} \
          -i NONE -n \
          -E -V1rplugins.log -s \
          +UpdateRemotePlugins +quit! > outfile 2>&1; then
          cat outfile
          echo -e "\nGenerating rplugin.vim failed!"
          exit 1
        fi
        rm "${placeholder "out"}/bin/nvim-wrapper"
      '')
      + ''
        rm $out/bin/nvim
        makeWrapper ${lib.escapeShellArgs finalMakeWrapperArgs} ${wrapperArgs}
      '';

    paths = [ neovim ];

    preferLocalBuild = true;

    nativeBuildInputs = [ makeWrapper ];
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
