{ nix
, makeWrapper
, python3Packages
, lib
, luarocks-package-updater
# , nix-prefetch-git
, nix-prefetch-scripts
# , luarocks-nix
, lua5_1
}:

python3Packages.buildPythonApplication {
  pname = "neovim-plugins-updater";
  version = "0.1";

  format = "other";

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.wrapPython
  ];
  propagatedBuildInputs = [
    python3Packages.gitpython
    (python3Packages.toPythonModule luarocks-package-updater)
  ];

  dontUnpack = true;

  #      --prefix PATH : "${path}"
  postFixup = ''
    echo "pluginupdate folder ${pluginupdate}"
    wrapProgram $out/bin/neovim-plugins-updater \
     --prefix PYTHONPATH : "${pluginupdate}"
  '';

  # installPhase =
  #   ''
  #   mkdir -p $out/bin
  #   cp ${./update.py} $out/bin/neovim-plugins-updater
  #
  #   wrapPythonProgramsIn "$out"
  # '';
    # # wrap python scripts
    # makeWrapperArgs+=( --prefix PATH : "${path}" --prefix PYTHONPATH : "$out/lib" )
    # wrapPythonProgramsIn "$out"
  shellHook = ''
    export PYTHONPATH="maintainers/scripts/pluginupdate-py:$PYTHONPATH"
  '';

  meta.mainProgram = "luarocks-packages-updater";
}

