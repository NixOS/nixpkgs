{
  nix,
  makeWrapper,
  python3Packages,
  lib,
  nix-prefetch-scripts,
  luarocks-nix,
  pluginupdate,
  lua5_1,
  lua5_2,
  lua5_3,
  lua5_4,
  luajit,
}:
let

  path = lib.makeBinPath [
    nix
    nix-prefetch-scripts
    luarocks-nix
    lua5_1
    lua5_2
    lua5_3
    lua5_4
    luajit
  ];

  attrs = builtins.fromTOML (builtins.readFile ./pyproject.toml);
  pname = attrs.project.name;
  inherit (attrs.project) version;
in

python3Packages.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = lib.cleanSource ./.;

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = [
    python3Packages.gitpython
  ];

  postFixup = ''
    echo "pluginupdate folder ${pluginupdate}"
    wrapProgram $out/bin/luarocks-packages-updater \
     --prefix PYTHONPATH : "${pluginupdate}" \
     --prefix PATH : "${path}"
  '';

  shellHook = ''
    export PYTHONPATH="maintainers/scripts/pluginupdate-py:$PYTHONPATH"
    export PATH="${path}:$PATH"
  '';

  meta = {
    inherit (attrs.project) description;
    license = lib.licenses.gpl3Only;
    homepage = attrs.project.urls.Homepage;
    mainProgram = "luarocks-packages-updater";
    maintainers = with lib.maintainers; [ teto ];
  };
}
