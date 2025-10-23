{
  lib,
  callPackage,
  fetchFromGitHub,
  makeWrapper,
  nixosTests,
  python3Packages,
  nltk-data,
  writeShellScript,
  nix-update-script,
}:

let
  version = "3.2.1";
  src = fetchFromGitHub {
    owner = "mealie-recipes";
    repo = "mealie";
    tag = "v${version}";
    hash = "sha256-LIWubw+iO17giSvGCl5LzI429725sisp5u4Z4usJOGA=";
  };

  frontend = callPackage (import ./mealie-frontend.nix src version) { };

  pythonpkgs = python3Packages;
  python = pythonpkgs.python;
in
pythonpkgs.buildPythonApplication rec {
  pname = "mealie";
  inherit version src;
  pyproject = true;

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
    fastapi
    html2text
    httpx
    ingredient-parser-nlp
    itsdangerous
    jinja2
    lxml
    openai
    orjson
    paho-mqtt
    pillow-heif
    psycopg2
    pydantic-settings
    pyhumps
    pyjwt
    python-dateutil
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
  '';

  postInstall =
    let
      start_script = writeShellScript "start-mealie" ''
        ${lib.getExe pythonpkgs.gunicorn} "$@" -k uvicorn.workers.UvicornWorker mealie.app:app;
      '';
      init_db = writeShellScript "init-mealie-db" ''
        ${python.interpreter} $OUT/${python.sitePackages}/mealie/db/init_db.py
      '';
    in
    ''
      mkdir -p $out/bin $out/libexec
      rm -f $out/bin/*

      makeWrapper ${start_script} $out/bin/mealie \
        --set PYTHONPATH "$out/${python.sitePackages}:${pythonpkgs.makePythonPath dependencies}" \
        --set STATIC_FILES "${frontend}"

      makeWrapper ${init_db} $out/libexec/init_db \
        --set PYTHONPATH "$out/${python.sitePackages}:${pythonpkgs.makePythonPath dependencies}" \
        --set OUT "$out"
    '';

  nativeCheckInputs = with pythonpkgs; [
    pytestCheckHook
    pytest-asyncio
  ];

  # Needed for tests
  preCheck = ''
    export NLTK_DATA=${nltk-data.averaged-perceptron-tagger-eng}
  '';

  disabledTestPaths = [
    # KeyError: 'alembic_version'
    "tests/unit_tests/services_tests/backup_v2_tests/test_backup_v2.py"
    "tests/unit_tests/services_tests/backup_v2_tests/test_alchemy_exporter.py"
    # sqlite3.OperationalError: no such table
    "tests/unit_tests/services_tests/scheduler/tasks/test_create_timeline_events.py"
    "tests/unit_tests/test_ingredient_parser.py"
    "tests/unit_tests/test_security.py"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) mealie;
    };
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
    maintainers = with maintainers; [
      litchipi
      anoa
    ];
    mainProgram = "mealie";
  };
}
