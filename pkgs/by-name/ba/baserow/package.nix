{
  lib,
  fetchFromGitHub,
  makeWrapper,
  python3,
  callPackage,
  nixosTests,
  antlr4_9,
  extraPremiumPatches ? [ ],
  postgresql,
  postgresqlTestHook
}:

let

  version = "1.27.2";
  src = fetchFromGitHub {
    owner = "bram2w";
    repo = "baserow";
    rev = "refs/tags/${version}";
    hash = "sha256-Dc7ehsn0OpnSWlEpoLXfUUE70Yd8KAZtHwB8fUO3Grc=";
  };

  python = python3.override {
    packageOverrides = self: super: {

      antlr4-python3-runtime = super.antlr4-python3-runtime.override {
        antlr4 = antlr4_9;
      };

      baserow_premium = self.buildPythonPackage rec {
        inherit src version;
        pname = "baserow_premium";
        pyproject = true;

        nativeBuildInputs = [ python.pkgs.setuptools ];

        patches = extraPremiumPatches;

        sourceRoot = "source/premium/backend";
      };

      baserow_enterprise = self.buildPythonPackage rec {
        inherit src version;
        pname = "baserow_enterprise";
        pyproject = true;

        nativeBuildInputs = [ python.pkgs.setuptools ];

        sourceRoot = "source/enterprise/backend";
      };

    };
  };
in

python.pkgs.buildPythonApplication rec {
  inherit src version;
  pname = "baserow";
  format = "pyproject";

  sourceRoot = "source/backend";

  postPatch = ''
    sed -i 's|../../../../tests/cases/|../tests/cases/|' src/baserow/test_utils/helpers.py

    sed -i 's|addopts = --disable-warnings|addopts = --disable-warnings --ignore=../enterprise/backend/tests|' pytest.ini
  '';

  nativeBuildInputs = [ makeWrapper ];

  dependencies = with python.pkgs; [
    advocate
    antlr4-python3-runtime
    autobahn
    azure-core
    azure-storage-blob
    baserow_enterprise
    baserow_premium
    boto3
    brotli
    cached-property
    celery-redbeat
    celery-singleton
    channels
    channels-redis
    daphne
    decorator
    dj-database-url
    django-cachalot
    django-celery-beat
    django-celery-email
    django-cors-headers
    django-health-check
    django-redis
    django-storages
    djangorestframework-simplejwt
    drf-spectacular
    faker
    google-api-core
    google-cloud-core
    google-cloud-storage
    google-crc32c
    google-resumable-media
    gunicorn
    importlib-resources
    isodate
    itsdangerous
    loguru
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-instrumentation
    opentelemetry-instrumentation-aiohttp-client
    opentelemetry-instrumentation-asgi
    opentelemetry-instrumentation-django
    opentelemetry-instrumentation-grpc
    opentelemetry-instrumentation-wsgi
    opentelemetry-sdk
    opentelemetry-semantic-conventions
    opentelemetry-util-http
    pillow
    posthog
    psutil
    psycopg2
    pyparsing
    pysaml2
    redis
    regex
    requests
    requests-oauthlib
    sentry-sdk
    service-identity
    setuptools
    tqdm
    twisted
    unicodecsv
    uvicorn
    validators
    watchgod
    zipp

    ollama
    openai
    langchain-core
    prosemirror
    opentelemetry-instrumentation-botocore
    opentelemetry-instrumentation-celery
    opentelemetry-instrumentation-psycopg2
    opentelemetry-instrumentation-redis
    opentelemetry-instrumentation-requests
    icalendar
  ] ++ uvicorn.optional-dependencies.standard;

  postInstall = ''
    wrapProgram $out/bin/baserow \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix DJANGO_SETTINGS_MODULE : "baserow.config.settings.base"

    cp -r "${src}/tests" $out/${python.sitePackages}/baserow/
  '';
  #
  nativeCheckInputs = with python.pkgs; [
    #baserow_premium
    boto3
    freezegun
    httpretty
    openapi-spec-validator
    pyinstrument
    pytestCheckHook
    pytest-django
    pytest-asyncio
    pytest-unordered
    responses
    zope_interface

    postgresql
    postgresqlTestHook
  ];

  env = {
    PGDATABASE = "test_baserow";
    PGUSER = "baserow";
  };

  preCheck = ''
    export DATABASE_HOST="localhost";
    export postgresqlEnableTCP=1;
    export postgresqlTestUserOptions="LOGIN SUPERUSER";
  '';

  checkInputs = with python.pkgs; [ fakeredis ];

  fixupPhase = ''
    cp -r src/baserow/contrib/database/{api,action,trash,formula,file_import} \
      $out/lib/${python.libPrefix}/site-packages/baserow/contrib/database/
    cp -r src/baserow/core/management/backup $out/lib/${python.libPrefix}/site-packages/baserow/core/management/
  '';

  disabledTests = [
    # Disable linting checks
    "flake8_plugins"
  ];

  disabledTestPaths = [
    # Disable enterprise & premium tests
    # because they require a database.
    "../enterprise/backend/tests"
    "../enterprise/backend/src"
    "../premium/backend/tests"
    "../premium/backend/src"
    # Disable database related tests
    "tests/baserow/contrib/database"
    "tests/baserow/api"
    "tests/baserow/core"
    "tests/baserow/ws"
    # Requires an installed app or something, investigate later
    "tests/baserow/contrib/builder/"
  ];

  pythonImportsCheck = [
    "baserow"
    "baserow_premium.config.settings"
    "baserow_enterprise.config.settings"
  ];

  DJANGO_SETTINGS_MODULE = "baserow.config.settings.test";

  passthru = {
    ui = callPackage ./frontend.nix { };
    #premium = baserow_premium;
    #enterprise = baserow_enterprise;
    # PYTHONPATH of all dependencies used by the package
    inherit python;
    pythonPath = python.pkgs.makePythonPath dependencies;

    tests = {
      inherit (nixosTests) baserow;
    };
  };

  meta = {
    description = "No-code database and Airtable alternative";
    homepage = "https://baserow.io";
    changelog = "https://github.com/bram2w/baserow/blob/${src.rev}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      julienmalka
      onny
      raitobezarius
    ];
  };
}
