{
  lib,
  fetchFromGitHub,
  makeWrapper,
  nixosTests,
  python3,
  nltk-data,
  writeShellScript,
  nix-update-script,

  # frontend
  fetchYarnDeps,
  dart-sass,
  nodejs,
  fixup-yarn-lock,
  stdenv,
  yarn,
  writableTmpDirAsHomeHook,
}:

let
  version = "3.20.1";
  src = fetchFromGitHub {
    owner = "mealie-recipes";
    repo = "mealie";
    tag = "v${version}";
    hash = "sha256-SkPbu0DUNyjo1ARjZX+BXq+3ehZqnrku9kPjwsTJfuM=";
  };

  frontend = stdenv.mkDerivation {
    name = "mealie-frontend";
    inherit version;
    src = "${src}/frontend";

    __structuredAttrs = true;

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = "${src}/frontend/yarn.lock";
      hash = "sha256-nhV93uRfKUa/G7ikJkd6l9IudgMk7PZ7ujZNnwIZ71k=";
    };

    nativeBuildInputs = [
      fixup-yarn-lock
      nodejs
      (yarn.override { inherit nodejs; })
      writableTmpDirAsHomeHook
      dart-sass
    ];

    env = {
      NUXT_TELEMETRY_DISABLED = 1;
    };

    configurePhase = ''
      runHook preConfigure

      sed -i 's+"@nuxt/fonts",+// NUXT FONTS DISABLED+g' nuxt.config.ts

      yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
      fixup-yarn-lock yarn.lock
      yarn install --offline --frozen-lockfile --no-progress --non-interactive --ignore-scripts
      patchShebangs node_modules

      substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
        --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["dart-sass"];'

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      yarn --offline generate
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mv .output/public $out
      runHook postInstall
    '';

    meta = {
      description = "Frontend for Mealie";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [
        litchipi
        esch
      ];
    };
  };

  python = python3;
  pythonpkgs = python.pkgs;
in
pythonpkgs.buildPythonApplication (finalAttrs: {
  pname = "mealie";
  inherit version src;
  pyproject = true;

  __structuredAttrs = true;

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
      freezegun
      html2text
      httpx
      httpx-curl-cffi
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
      yt-dlp
    ]
    ++ uvicorn.optional-dependencies.standard;

  postPatch = ''
    rm -rf dev # Do not need dev scripts & code

    substituteInPlace pyproject.toml \
     --replace-fail '"setuptools==82.0.1"' '"setuptools"'

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
        --set PYTHONPATH "$out/${python.sitePackages}:${pythonpkgs.makePythonPath finalAttrs.passthru.dependencies}" \
        --set STATIC_FILES "${finalAttrs.passthru.frontend}"

      makeWrapper ${init_db} $out/libexec/init_db \
        --set PYTHONPATH "$out/${python.sitePackages}:${pythonpkgs.makePythonPath finalAttrs.passthru.dependencies}" \
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
    inherit frontend;
    updateScript = nix-update-script {
      extraArgs = [
        "-s"
        "frontend"
      ];
    };
    tests = {
      inherit (nixosTests) mealie;
    };
  };

  meta = {
    description = "Self hosted recipe manager and meal planner";
    longDescription = ''
      Mealie is a self hosted recipe manager and meal planner with a REST API and a reactive frontend
      application built in NuxtJS for a pleasant user experience for the whole family. Easily add recipes into your
      database by providing the URL and Mealie will automatically import the relevant data or add a family recipe with
      the UI editor.
    '';
    homepage = "https://mealie.io";
    changelog = "https://github.com/mealie-recipes/mealie/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      litchipi
      anoa
      esch
    ];
    mainProgram = "mealie";
  };
})
