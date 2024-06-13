{ lib
, callPackage
, fetchFromGitHub
, makeWrapper
, nixosTests
, python3Packages
, stdenv
, writeShellScript
}:

let
  version = "1.7.0";
  src = fetchFromGitHub {
    owner = "mealie-recipes";
    repo = "mealie";
    rev = "v${version}";
    hash = "sha256-z7kLBDzvzPWY7XmpROMpw3LcDpsl+hA+w1SdhrD/yNU=";
  };

  frontend = callPackage (import ./mealie-frontend.nix src version) { };

  pythonpkgs = python3Packages;
  python = pythonpkgs.python;

  crfpp = stdenv.mkDerivation {
    pname = "mealie-crfpp";
    version = "unstable-2024-02-12";
    src = fetchFromGitHub {
      owner = "mealie-recipes";
      repo = "crfpp";
      rev = "c56dd9f29469c8a9f34456b8c0d6ae0476110516";
      hash = "sha256-XNps3ZApU8m07bfPEnvip1w+3hLajdn9+L5+IpEaP0c=";
    };
  };
in pythonpkgs.buildPythonPackage rec {
  pname = "mealie";
  inherit version src;
  pyproject = true;

  nativeBuildInputs = [
    pythonpkgs.poetry-core
    pythonpkgs.pythonRelaxDepsHook
    makeWrapper
  ];

  dontWrapPythonPrograms = true;

  doCheck = false;
  pythonRelaxDeps = true;

  propagatedBuildInputs = with pythonpkgs; [
    aiofiles
    alembic
    aniso8601
    appdirs
    apprise
    authlib
    bcrypt
    extruct
    fastapi
    gunicorn
    html2text
    httpx
    jinja2
    lxml
    openai
    orjson
    paho-mqtt
    pillow
    pillow-heif
    psycopg2
    pydantic-settings
    pyhumps
    pyjwt
    python-dotenv
    python-ldap
    python-multipart
    python-slugify
    pyyaml
    rapidfuzz
    recipe-scrapers
    sqlalchemy
    tzdata
    uvicorn
  ];

  postPatch = ''
    substituteInPlace mealie/__init__.py \
      --replace-fail '__version__ = ' '__version__ = "v${version}" #'
  '';

  postInstall = let
    start_script = writeShellScript "start-mealie" ''
      ${lib.getExe pythonpkgs.gunicorn} "$@" -k uvicorn.workers.UvicornWorker mealie.app:app;
    '';
    init_db = writeShellScript "init-mealie-db" ''
      ${python.interpreter} $OUT/${python.sitePackages}/mealie/scripts/install_model.py
      ${python.interpreter} $OUT/${python.sitePackages}/mealie/db/init_db.py
    '';
  in ''
    mkdir -p $out/config $out/bin $out/libexec
    rm -f $out/bin/*

    substitute ${src}/alembic.ini $out/config/alembic.ini \
      --replace-fail 'script_location = alembic' 'script_location = ${src}/alembic'

    makeWrapper ${start_script} $out/bin/mealie \
      --set PYTHONPATH "$out/${python.sitePackages}:${python.pkgs.makePythonPath propagatedBuildInputs}" \
      --set LD_LIBRARY_PATH "${crfpp}/lib" \
      --set STATIC_FILES "${frontend}" \
      --set PATH "${lib.makeBinPath [ crfpp ]}"

    makeWrapper ${init_db} $out/libexec/init_db \
      --set PYTHONPATH "$out/${python.sitePackages}:${python.pkgs.makePythonPath propagatedBuildInputs}" \
      --set OUT "$out"
  '';

  checkInputs = with python.pkgs; [
    pytestCheckHook
  ];

  passthru.tests = {
    inherit (nixosTests) mealie;
  };

  meta = with lib; {
    description = "Self hosted recipe manager and meal planner";
    longDescription = ''
      Mealie is a self hosted recipe manager and meal planner with a REST API and a reactive frontend
      application built in NuxtJS for a pleasant user experience for the whole family. Easily add recipes into your
      database by providing the URL and Mealie will automatically import the relevant data or add a family recipe with
      the UI editor.
    '';
    homepage = "https://mealie.io";
    changelog = "https://github.com/mealie-recipes/mealie/releases/tag/${src.rev}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ litchipi anoa ];
    mainProgram = "mealie";
  };
}
