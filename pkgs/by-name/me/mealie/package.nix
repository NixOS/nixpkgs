{ lib
, stdenv
, callPackage
, fetchFromGitHub
, fetchpatch
, makeWrapper
, nixosTests
, python3Packages
, writeShellScript
}:

let
  version = "1.11.0";
  src = fetchFromGitHub {
    owner = "mealie-recipes";
    repo = "mealie";
    rev = "v${version}";
    hash = "sha256-tBbvmM66zCNpKqeekPY48j0t5PjLHeyQ8+kJ6755ivo=";
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

    # Can remove once the `register` keyword is removed from source files
    # Configure overwrites CXXFLAGS so patch it in the Makefile
    postConfigure = lib.optionalString stdenv.cc.isClang ''
      substituteInPlace Makefile \
        --replace-fail "CXXFLAGS = " "CXXFLAGS = -std=c++14 "
    '';
  };
in

pythonpkgs.buildPythonApplication rec {
  pname = "mealie";
  inherit version src;
  pyproject = true;

  patches = [
    # Pull in https://github.com/mealie-recipes/mealie/pull/4002 manually until
    # it lands in an upstream mealie release.
    # See https://github.com/NixOS/nixpkgs/issues/321623.
    ( fetchpatch {
        url = "https://github.com/mealie-recipes/mealie/commit/65ece35966120479db903785b22e9f2645f72aa4.patch";
        hash = "sha256-4Nc0dFJrZ7ElN9rrq+CFpayKsrRjRd24fYraUFTzcH8=";
    })
  ];

  build-system = with pythonpkgs; [ poetry-core ];

  nativeBuildInputs = [ makeWrapper ];

  dontWrapPythonPrograms = true;

  pythonRelaxDeps = true;

  dependencies = with pythonpkgs; [
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
    rm -rf dev # Do not need dev scripts & code

    substituteInPlace mealie/__init__.py \
      --replace-fail '__version__ = ' '__version__ = "v${version}" #'

    substituteInPlace mealie/services/backups_v2/alchemy_exporter.py \
      --replace-fail 'PROJECT_DIR = ' "PROJECT_DIR = Path('$out') #"

    substituteInPlace mealie/db/init_db.py \
      --replace-fail 'PROJECT_DIR = ' "PROJECT_DIR = Path('$out') #"

    substituteInPlace mealie/services/backups_v2/alchemy_exporter.py \
      --replace-fail '"script_location", path.join(PROJECT_DIR, "alembic")' '"script_location", "${src}/alembic"'
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
    mkdir -p $out/bin $out/libexec
    rm -f $out/bin/*

    substitute ${src}/alembic.ini $out/alembic.ini \
      --replace-fail 'script_location = alembic' 'script_location = ${src}/alembic'

    makeWrapper ${start_script} $out/bin/mealie \
      --set PYTHONPATH "$out/${python.sitePackages}:${pythonpkgs.makePythonPath dependencies}" \
      --set LD_LIBRARY_PATH "${crfpp}/lib" \
      --set STATIC_FILES "${frontend}" \
      --set PATH "${lib.makeBinPath [ crfpp ]}"

    makeWrapper ${init_db} $out/libexec/init_db \
      --set PYTHONPATH "$out/${python.sitePackages}:${pythonpkgs.makePythonPath dependencies}" \
      --set OUT "$out"
  '';

  nativeCheckInputs = with pythonpkgs; [ pytestCheckHook ];

  disabledTestPaths = [
    # KeyError: 'alembic_version'
    "tests/unit_tests/services_tests/backup_v2_tests/test_backup_v2.py"
    "tests/unit_tests/services_tests/backup_v2_tests/test_alchemy_exporter.py"
    # sqlite3.OperationalError: no such table
    "tests/unit_tests/services_tests/scheduler/tasks/test_create_timeline_events.py"
    "tests/unit_tests/test_ingredient_parser.py"
    "tests/unit_tests/test_security.py"
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
