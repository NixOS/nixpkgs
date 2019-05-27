{ stdenv, lib, makeWrapper
, vimUtils, writeText
, bundlerEnv, ruby
, nodejs
, nodePackages
, pythonPackages
, python3Packages
, haskellPackages
}:
with stdenv.lib;

neovim:

let

  wrapper = structuredConfigure:
  let

    module = import ./module.nix;

    # Generate init.vim configuration
    cfg =  (lib.evalModules {
      specialArgs = {
        inherit vimUtils python3Packages bundlerEnv ruby pythonPackages haskellPackages;
        inherit nodePackages;
      };
      modules = [
        module
        { customRC = structuredConfigure.configure.customRC or "";}
        structuredConfigure
      ];
    }).config;

    binPath = makeBinPath (optionals cfg.withRuby [cfg.rubyEnv] ++ optionals cfg.withNodeJs [nodejs]);

    neovimrcFile = writeText "init.vim" cfg.neovimRC;
  in
  stdenv.mkDerivation {
      name = "neovim-${stdenv.lib.getVersion neovim}";
      buildCommand = let bin="${neovim}/bin/nvim"; in ''
        if [ ! -x "${bin}" ]
        then
            echo "cannot find executable file \`${bin}'"
            exit 1
        fi

        makeWrapper "$(readlink -v --canonicalize-existing "${bin}")" \
          "$out/bin/nvim"         --suffix PATH : ${binPath} \
        ${optionalString cfg.withRuby '' --set GEM_HOME ${cfg.rubyEnv}/${cfg.rubyEnv.ruby.gemPath}'' }
      ''
      + optionalString (!stdenv.isDarwin) ''
        # copy and patch the original neovim.desktop file
        mkdir -p $out/share/applications
        substitute ${neovim}/share/applications/nvim.desktop $out/share/applications/nvim.desktop \
          --replace 'TryExec=nvim' "TryExec=$out/bin/nvim" \
          --replace 'Name=Neovim' 'Name=WrappedNeovim'
      ''
      + optionalString cfg.withPython ''
        makeWrapper ${cfg.pythonEnv}/bin/python $out/bin/nvim-python --unset PYTHONPATH
      '' + optionalString cfg.withPython3 ''
        makeWrapper ${cfg.python3Env}/bin/python3 $out/bin/nvim-python3 --unset PYTHONPATH
      '' + optionalString cfg.withRuby ''
        ln -s ${cfg.rubyEnv}/bin/neovim-ruby-host $out/bin/nvim-ruby
      '' + optionalString cfg.vimAlias ''
        ln -s $out/bin/nvim $out/bin/vim
      '' + optionalString cfg.viAlias ''
        ln -s $out/bin/nvim $out/bin/vi
      '' + optionalString (cfg.updateRemotePlugins) ''
        echo "Generating remote plugin manifest"
        export NVIM_RPLUGIN_MANIFEST=$out/rplugin.vim
        # Launch neovim with a vimrc file containing only the generated plugin
        # code. Pass various flags to disable temp file generation
        # (swap/viminfo) and redirect errors to stderr.
        # Only display the log on error since it will contain a few normally
        # irrelevant messages.
        if ! $out/bin/nvim \
          -u ${neovimrcFile} \
          -i NONE -n \
          -E -V1rplugins.log -s \
          +UpdateRemotePlugins +quit! > outfile 2>&1; then
          cat outfile
          echo -e "\nGenerating rplugin.vim failed!"
          exit 1
        fi
        unset NVIM_RPLUGIN_MANIFEST

        # this relies on a patched neovim, see
        # https://github.com/neovim/neovim/issues/9413
        wrapProgram $out/bin/nvim \
          --set NVIM_SYSTEM_RPLUGIN_MANIFEST $out/rplugin.vim \
          --add-flags "--cmd \"source ${neovimrcFile}\""
      '';

    preferLocalBuild = true;

    buildInputs = [makeWrapper];
    passthru = { unwrapped = neovim; };

    meta = neovim.meta // {
      description = neovim.meta.description;
      hydraPlatforms = [];
      # prefer wrapper over the package
      priority = (neovim.meta.priority or 0) - 1;
    };
  };
in
  lib.makeOverridable wrapper
