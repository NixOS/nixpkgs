{ stdenv, symlinkJoin, lib, makeWrapper
, vimUtils
, writeText
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
      wrapperArgs ? []
    , manifestRc ? null
    , withPython ? true, pythonEnv ? null
    , withPython3 ? true,  python3Env ? null
    , withNodeJs? false
    , withRuby ? true, rubyEnv ? null
    , vimAlias ? false
    , viAlias ? false
    , ...
  }:
  let

  finalMakeWrapperArgs =
    [ "${neovim}/bin/nvim" "${placeholder "out"}/bin/nvim" ] ++ wrapperArgs
  ;
  in
  symlinkJoin {
      name = "neovim-${stdenv.lib.getVersion neovim}";
      # Remove the symlinks created by symlinkJoin which we need to perform
      # extra actions upon
      postBuild = ''
        # rm $out/bin/nvim
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
        ln -s ${nodePackages.neovim}/bin/neovim-node-host $out/bin/nvim-node
      ''
      + optionalString vimAlias ''
        ln -s $out/bin/nvim $out/bin/vim
      ''
      + optionalString viAlias ''
        ln -s $out/bin/nvim $out/bin/vi
      ''
      + optionalString (manifestRc != null) ''
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
          -u ${writeText "manifest.vim" manifestRc} \
          -i NONE -n \
          -E -V1rplugins.log -s \
          +UpdateRemotePlugins +quit! > outfile 2>&1; then
          cat outfile
          echo -e "\nGenerating rplugin.vim failed!"
          exit 1
        fi
      ''
      + ''
        rm $out/bin/nvim
        makeWrapper ${lib.escapeShellArgs finalMakeWrapperArgs}
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
