{
  python312,
  lib,
  callPackage,
  writeShellScript,
  makeWrapper,
}:

let
  common = callPackage ./common.nix { };
  frontend = callPackage ./frontend.nix { };
  python = python312;
  hishel_0_1 = python.pkgs.hishel.overrideAttrs (old: rec {
    version = "0.1.5";
    src = old.src.override {
      tag = version;
      hash = "sha256-OyQR/ruowNk5z4ITRHcIJn1kc0xLZiofmxajf6hNR9k=";
    };
  });
in

python.pkgs.buildPythonPackage rec {

  pname = "spoolman";
  inherit (common) version src;

  pyproject = true;

  nativeBuildInputs = [
    makeWrapper
    python.pkgs.setuptools
    python.pkgs.pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "setuptools"
    "websockets"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail psycopg2-binary psycopg2

    # upstream removed [build-system] in 0.23.x, causing setuptools
    # to fail on the flat layout with multiple top-level directories
    cat >> pyproject.toml <<EOF

    [build-system]
    requires = ["setuptools"]
    build-backend = "setuptools.build_meta"

    [tool.setuptools.packages.find]
    include = ["spoolman*"]
    EOF
  '';

  propagatedBuildInputs = with python.pkgs; [
    uvloop
    alembic
    aiomysql
    anysqlite
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
      mkdir -p $out/runpath/client/dist $out/bin
      cp -r $src/* $out/runpath
      cp -r ${frontend}/* $out/runpath/client/dist

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
