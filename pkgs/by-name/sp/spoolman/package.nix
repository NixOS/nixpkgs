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
in

python.pkgs.buildPythonPackage rec {

  pname = "spoolman";
  inherit (common) version src;

  pyproject = true;

  nativeBuildInputs = [
    makeWrapper
    python.pkgs.pdm-backend
    python.pkgs.pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "setuptools" ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail psycopg2-binary psycopg2
  '';

  propagatedBuildInputs = with python.pkgs; [
    uvloop
    alembic
    asyncpg
    fastapi
    hishel
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
