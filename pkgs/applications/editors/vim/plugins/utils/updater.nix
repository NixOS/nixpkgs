{
  lib,
  buildPythonApplication,
  makeWrapper,
  nix,
  nix-prefetch-git,
  nurl,
  python3Packages,

  # optional
  neovim-unwrapped,
}:
buildPythonApplication {
  pname = "vim-plugins-updater";
  version = "0.1";

  pyproject = false;

  nativeBuildInputs = [
    makeWrapper
    python3Packages.wrapPython
  ];

  pythonPath = [
    python3Packages.requests
    python3Packages.nixpkgs-plugin-update
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp ${./update.py} $out/bin/vim-plugins-updater
    cp ${./get-plugins.nix} $out/bin/get-plugins.nix

    # wrap python scripts
    makeWrapperArgs+=( --prefix PATH : "${
      lib.makeBinPath [
        nix
        nix-prefetch-git
        neovim-unwrapped
        nurl
      ]
    }" --prefix PYTHONPATH : "${./.}" )
    wrapPythonPrograms
  '';

  shellHook = ''
    export PYTHONPATH=pkgs/applications/editors/vim/plugins:$PYTHONPATH
  '';

  meta.mainProgram = "vim-plugins-updater";
}
