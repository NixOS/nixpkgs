{
  python3,
  lib,
  callPackage,
  writeShellScript,
  makeWrapper,
}:

let
  common = callPackage ./common.nix { };
  frontend = callPackage ./frontend.nix { };
  frontend-v2 = callPackage ./frontend-v2.nix { };
  python = python3;
  # Spoolman still uses the Hishel 0.1 cache API, but nixpkgs has Hishel 1.x.
  hishel_0_1 = python.pkgs.hishel.overridePythonAttrs (old: rec {
    version = "0.1.5";
    src = old.src.override {
      tag = version;
      hash = "sha256-OyQR/ruowNk5z4ITRHcIJn1kc0xLZiofmxajf6hNR9k=";
    };
    dependencies =
      old.dependencies
      ++ (with python.pkgs; [
        anyio
        anysqlite
        httpx
      ]);
  });
in

python.pkgs.buildPythonPackage rec {

  pname = "spoolman";
  inherit (common) version src;

  pyproject = true;

  build-system = [ python.pkgs.setuptools ];

  nativeBuildInputs = [
    makeWrapper
    python.pkgs.pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "websockets" ];

  postPatch = ''
    # nixpkgs provides psycopg2 instead of the bundled-binary distribution.
    substituteInPlace pyproject.toml --replace-fail psycopg2-binary psycopg2

    # Limit setuptools discovery to the Python package in upstream's flat tree.
    cat >> pyproject.toml <<EOF

    [tool.setuptools.packages.find]
    include = ["spoolman*"]
    EOF
  '';

  propagatedBuildInputs = with python.pkgs; [
    uvloop
    alembic
    aiomysql
    asyncpg
    fastapi
    hishel_0_1
    httptools
    httpx
    aiosqlite
    platformdirs
    prometheus-client
    psycopg2
    pydantic
    scheduler
    setuptools
    sqlalchemy
    sqlalchemy-cockroachdb
    uvicorn
    websockets
  ];

  pythonImportsCheck = [ "spoolman" ];

  postInstall =
    let
      start_script = writeShellScript "start-spoolman" ''
        ${lib.getExe python.pkgs.uvicorn} "$@" spoolman.main:app;
      '';
    in
    ''
      mkdir -p $out/runpath/client/dist $out/runpath/client_v2/build $out/bin
      cp -r $src/* $out/runpath
      cp -r ${frontend}/* $out/runpath/client/dist
      cp -r ${frontend-v2}/* $out/runpath/client_v2/build

      makeWrapper ${start_script} $out/bin/spoolman \
      --chdir $out/runpath \
      --prefix PYTHONPATH : "$out/${python.sitePackages}" \
      --prefix PYTHONPATH : "${python.pkgs.makePythonPath propagatedBuildInputs}" \
      --prefix PATH : "${python.pkgs.alembic}/bin"
    '';

  meta = common.meta // {
    description = "Spoolman server";
    mainProgram = "spoolman";
  };
}
