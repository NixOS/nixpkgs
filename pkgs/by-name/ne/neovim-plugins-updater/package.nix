{ nix
, makeWrapper
, python3Packages
, lib
, luarocks-packages-updater
, pluginupdate
, luarocks-nix
}:
let
  path = lib.makeBinPath [
    luarocks-nix
  ];

  attrs = builtins.fromTOML (builtins.readFile ./pyproject.toml);
  pname = attrs.project.name;
  inherit (attrs.project) version;
in

python3Packages.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = lib.cleanSource ./.;

  nativeBuildInputs = [
    makeWrapper
    python3Packages.setuptools
  ];
  propagatedBuildInputs = [
    python3Packages.gitpython
    (python3Packages.toPythonModule luarocks-packages-updater)
  ];


  #      --prefix PATH : "${path}"
  postFixup = ''
    echo "pluginupdate folder ${pluginupdate}"
    wrapProgram $out/bin/neovim-plugins-updater \
     --prefix PYTHONPATH : "${pluginupdate}" \
     --prefix PATH : "${path}"

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

  meta.mainProgram = "neovim-plugins-updater";
}

