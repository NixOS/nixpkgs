{ stdenv, lib, makeDesktopItem, makeWrapper
, vimUtils
, bundlerEnv, ruby
, pythonPackages
, python3Packages
}:
with stdenv.lib;

neovim:

let
  wrapper = {
    name ? "neovim"
    , withPython ? true,  extraPythonPackages ? []
    , withPython3 ? true,  extraPython3Packages ? []
    , withRuby ? true
    , withPyGUI ? false
    , vimAlias ? false
    , viAlias ? false
    , configure ? null
  }:
  let

  rubyEnv = bundlerEnv {
    name = "neovim-ruby-env";
    gemdir = ./ruby_provider;
    postBuild = ''
      ln -sf ${ruby}/bin/* $out/bin
    '';
  };

  pluginPythonPackages = if configure == null then [] else builtins.concatLists
    (map ({ pythonDependencies ? [], ...}: pythonDependencies)
         (vimUtils.requiredPlugins configure));
  pythonEnv = pythonPackages.python.buildEnv.override {
    extraLibs = (
        if withPyGUI
          then [ pythonPackages.neovim_gui ]
          else [ pythonPackages.neovim ]
      ) ++ extraPythonPackages ++ pluginPythonPackages;
    ignoreCollisions = true;
  };

  pluginPython3Packages = if configure == null then [] else builtins.concatLists
    (map ({ python3Dependencies ? [], ...}: python3Dependencies)
         (vimUtils.requiredPlugins configure));
  python3Env = python3Packages.python.buildEnv.override {
    extraLibs = [ python3Packages.neovim ] ++ extraPython3Packages ++ pluginPython3Packages;
    ignoreCollisions = true;
  };

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
          "$out/bin/nvim" --add-flags " \
        --cmd \"${if withPython then "let g:python_host_prog='$out/bin/nvim-python'" else "let g:loaded_python_provider = 1"}\" \
        --cmd \"${if withPython3 then "let g:python3_host_prog='$out/bin/nvim-python3'" else "let g:loaded_python3_provider = 1"}\" \
        --cmd \"${if withRuby then "let g:ruby_host_prog='$out/bin/nvim-ruby'" else "let g:loaded_ruby_provider=1"}\" " \
        --unset PYTHONPATH \
         ${optionalString withRuby '' --suffix PATH : ${rubyEnv}/bin --set GEM_HOME ${rubyEnv}/${rubyEnv.ruby.gemPath}'' }

      ''
      + optionalString (!stdenv.isDarwin) ''
        # copy and patch the original neovim.desktop file
        mkdir -p $out/share/applications
        substitute ${neovim}/share/applications/nvim.desktop $out/share/applications/nvim.desktop \
          --replace 'TryExec=nvim' "TryExec=$out/bin/nvim" \
          --replace 'Name=Neovim' 'Name=WrappedNeovim'
      ''
      + optionalString withPython ''
      ln -s ${pythonEnv}/bin/python $out/bin/nvim-python
    '' + optionalString withPython3 ''
      ln -s ${python3Env}/bin/python3 $out/bin/nvim-python3
    '' + optionalString withRuby ''
      ln -s ${rubyEnv}/bin/neovim-ruby-host $out/bin/nvim-ruby
    ''
      + optionalString withPyGUI ''
      makeWrapper "${pythonEnv}/bin/pynvim" "$out/bin/pynvim" \
        --prefix PATH : "$out/bin"
    '' + optionalString vimAlias ''
      ln -s $out/bin/nvim $out/bin/vim
    '' + optionalString viAlias ''
      ln -s $out/bin/nvim $out/bin/vi
    '' + optionalString (configure != null) ''
    wrapProgram $out/bin/nvim --add-flags "-u ${vimUtils.vimrcFile configure}"
    ''
    ;

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
