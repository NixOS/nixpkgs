{ buildPythonApplication
, nix
, makeWrapper
, python3Packages
, lib
, nix-prefetch-git

# optional
, vimPlugins
, neovim
}:
let
  my_neovim = neovim.override {
    configure.packages.all.start = [ vimPlugins.nvim-treesitter ];
  };

in
buildPythonApplication {
  format = "other";
  pname = "vim-plugins-updater";
  version = "0.1";

  nativeBuildInputs = [
    makeWrapper
    python3Packages.wrapPython
  ];

  pythonPath = [
    python3Packages.gitpython
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp ${./update.py} $out/bin/vim-plugins-updater
    cp ${./get-plugins.nix} $out/get-plugins.nix
    cp ${./nvim-treesitter/update.py} $out/lib/treesitter.py
    cp ${../../../../../maintainers/scripts/pluginupdate.py} $out/lib/pluginupdate.py

    # wrap python scripts
    makeWrapperArgs+=( --prefix PATH : "${lib.makeBinPath [ nix nix-prefetch-git my_neovim ]}" --prefix PYTHONPATH : "$out/lib" )
    wrapPythonPrograms
  '';

  meta.mainProgram = "vim-plugins-updater";
}

