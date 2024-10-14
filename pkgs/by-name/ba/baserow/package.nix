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
  postgresqlTestHook,
}:

let

  version = "1.28.0";
  src = fetchFromGitHub {
    owner = "bram2w";
    repo = "baserow";
    rev = "refs/tags/${version}";
    hash = "sha256-wleBF1OwqaNt+xOZqz9S9E8wEhPJ4fLdWX2NLD4TcVA=";
  };

  python = python3.override {
    packageOverrides = self: super: {

      antlr4-python3-runtime = super.antlr4-python3-runtime.override {
        antlr4 = antlr4_9;
      };
      django = super.django_5;

      baserow_premium = self.buildPythonPackage rec {
        inherit src version;
        pname = "baserow_premium";
        pyproject = true;

        nativeBuildInputs = [ python.pkgs.setuptools ];

        patches = extraPremiumPatches;

        sourceRoot = "source/premium/backend";

        postInstall = ''
          cp src/baserow_premium/public_key_debug.pem $out/${python.sitePackages}/baserow_premium/
          cp src/baserow_premium/public_key.pem $out/${python.sitePackages}/baserow_premium/
          cp -r src/baserow_premium/prompts $out/${python.sitePackages}/baserow_premium/
        '';
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

    # Support for Django 5.1
    substituteInPlace src/baserow/contrib/database/fields/fields.py --replace-fail "is_hidden()" "hidden"
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
    baserow_premium
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

  pytestFlagsArray = [
    "--exitfirst"
  ];

  preCheck = ''
    export PGUSER="baserow"
    export DATABASE_HOST="localhost"
    export postgresqlEnableTCP=1
    export postgresqlTestUserOptions="LOGIN SUPERUSER"
  '';

  checkInputs = with python.pkgs; [
    fakeredis
    pytest-mock
  ];

  fixupPhase = ''
    cp -r src/baserow/contrib/database/{api,action,trash,formula,file_import} \
      $out/lib/${python.libPrefix}/site-packages/baserow/contrib/database/
    cp -r src/baserow/core/management/backup $out/lib/${python.libPrefix}/site-packages/baserow/core/management/
  '';

  disabledTests = [
    # Disable linting checks
    "flake8_plugins"

    # Needs write permissions
    "test_generate_ai_field_value_view_generative_ai_with_files"
    "test_upload_files_from_file_field"
    "test_audit_log_can_export_to_csv_all_entries"
    "test_audit_log_can_export_to_csv_filtered_entries"
    "test_workspace_audit_log_can_export_to_csv_filtered_entries"
    "test_email_notifications_are_created_correctly"
    "test_remove_unused_personal_views"
    "test_files_are_served_by_base_file_storage_by_default"
    "test_files_can_be_served_by_the_backend"
    "test_secure_file_serve_requires_license_to_download_files"
    "test_files_can_be_downloaded_by_the_backend_with_valid_license"
    # AttributeError: 'called_once' is not a valid assertion. Use a spec for the mock if 'called_once' is meant to be an attribute
    "test_notification_creation_on_creating_row_comment_mention"
    "test_notify_only_new_mentions_when_updating_a_comment"
    # Test requires internet connection
    "test_create_and_get_oauth2_provider"
    "test_update_oauth2_provider"
    # AssertionError: assert '<?xml versio...</row></rows>' == '<?xml versio...</row></rows>'
    "test_can_export_every_interesting_different_field_to_xml"
    # AssertionError: assert {'count': 0, ...'results': []} == {'count': 1, ...a progetto'}]}
    "test_audit_log_action_types_are_translated_in_the_admin_language"
    "test_audit_log_entries_are_translated_in_the_user_language"
  ];

  #disabledTestPaths = [
  #  # Disable enterprise & premium tests
  #  # because they require a database.
  #  "../enterprise/backend/tests"
  #  "../enterprise/backend/src"
  #  "../premium/backend/tests"
  #  "../premium/backend/src"
  #  # Disable database related tests
  #  "tests/baserow/contrib/database"
  #  "tests/baserow/api"
  #  "tests/baserow/core"
  #  "tests/baserow/ws"
  #  # Requires an installed app or something, investigate later
  #  "tests/baserow/contrib/builder/"
  #];

  pythonImportsCheck = [
    "baserow"
    "baserow_premium.config.settings"
    "baserow_enterprise.config.settings"
  ];

  DJANGO_SETTINGS_MODULE = "baserow.config.settings.test";

  passthru = {
    frontend = callPackage ./frontend.nix { };
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
