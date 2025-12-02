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
  version = "3.5.0";
  src = fetchFromGitHub {
    owner = "mealie-recipes";
    repo = "mealie";
    tag = "v${version}";
    hash = "sha256-rZOmu2xplIyMgX0uk5XCKf79qWfftHVELYNXdlzYkrY=";
  };

  frontend = callPackage (import ./mealie-frontend.nix src version) { };

  pythonpkgs = python3Packages;
  python = pythonpkgs.python;
in
pythonpkgs.buildPythonApplication rec {
  pname = "mealie";
  inherit version src;
  pyproject = true;

  build-system = with pythonpkgs; [ setuptools ];

  nativeBuildInputs = [ makeWrapper ];

  dontWrapPythonPrograms = true;

  pythonRelaxDeps = true;

  dependencies =
    with pythonpkgs;
    [
      aiofiles
      alembic
      aniso8601
      appdirs
      apprise
      authlib
      bcrypt
      beautifulsoup4
      extruct
      fastapi
      html2text
      httpx
      ingredient-parser-nlp
      isodate
      itsdangerous
      jinja2
      lxml
      openai
      orjson
      paho-mqtt
      pillow
      pillow-heif
      psycopg2 # pgsql optional-dependencies
      pydantic
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
      requests
      sqlalchemy
      text-unidecode
      typing-extensions
      tzdata
      uvicorn
    ]
    ++ uvicorn.optional-dependencies.standard;

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

  disabledTests = [
    # pydantic_core._pydantic_core.ValidationError: 1 validation error
    "test_pg_connection_url_encode_password"
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
