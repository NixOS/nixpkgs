{ buildPythonApplication
, nix
, makeWrapper
, python3Packages
, lib
, nix-prefetch-git
, nurl

# optional
, neovim-unwrapped
}:
buildPythonApplication {
  pname = "vim-plugins-updater";
  version = "0.1";

  format = "other";

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
    cp ${./get-plugins.nix} $out/bin/get-plugins.nix

    # wrap python scripts
    makeWrapperArgs+=( --prefix PATH : "${lib.makeBinPath [
      nix nix-prefetch-git neovim-unwrapped nurl ]}" --prefix PYTHONPATH : "${./.}:${../../../../../maintainers/scripts}" )
    wrapPythonPrograms
  '';

  shellHook = ''
    export PYTHONPATH=pkgs/applications/editors/vim/plugins:maintainers/scripts:$PYTHONPATH
    '';

  meta.mainProgram = "vim-plugins-updater";
}

