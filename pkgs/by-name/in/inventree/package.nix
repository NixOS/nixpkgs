{
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  nodejs,
  python313,
  stdenv,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
}:
let
  python3 = python313.override {
    self = python3;
    packageOverrides = _: super: {
      django = super.django_5_2;
      django_4 = super.django_5_2; # For django-stdimage
    };
  };

  version = "1.2.3";
  src = fetchFromGitHub {
    owner = "inventree";
    repo = "inventree";
    tag = "${version}";
    hash = "sha256-2Rye1znvF3GfzcLYj09+cIbf5MHbmpEQBj818LtW6O4=";
  };

  frontend =
    let
      frontendSource = src + "/src/frontend";
    in
    stdenv.mkDerivation (finalAttrs: {

      pname = "inventree-frontend";
      inherit version;

      src = frontendSource;

      yarnOfflineCache = fetchYarnDeps {
        yarnLock = finalAttrs.src + "/yarn.lock";
        hash = "sha256-tZHrl6NC4MGpmH7+Ge2V/y9FRNd9NdbQ/NreHE10b10=";
      };

      nativeBuildInputs = [
        nodejs
        yarnConfigHook
        yarnBuildHook
        yarnInstallHook
      ];

      buildPhase = ''
        mkdir -p $out

        export PATH=$PATH:$TMP/frontend/node_modules/.bin
        substituteInPlace $TMP/frontend/vite.config.ts --replace-warn "../../src/backend/InvenTree/web/static/web" "$out/static/web"

        npm run extract
        npm run compile
        npm run build
      '';
    });
in
python3.pkgs.buildPythonApplication rec {
  pname = "inventree";
  pyproject = true;
  inherit version src;

  dependencies =
    with python3.pkgs;
    [
      django_5_2
      dj-rest-auth
      django-allauth
      django-cleanup
      django-cors-headers
      django-crispy-forms
      django-dbbackup
      django-error-report-2
      django-filter
      django-flags
      django-formtools
      django-ical
      django-import-export
      django-maintenance-mode
      django-markdownify
      django-money
      django-mptt
      django-mailbox
      django-anymail
      django-q2
      django-redis
      django-sesame
      django-sql-utils
      django-sslserver
      django-stdimage
      django-storages
      django-structlog
      django-taggit
      django-oauth-toolkit
      django-otp
      django-user-sessions
      django-weasyprint
      standard-imghdr
      django-xforwardedfor-middleware
      djangorestframework-simplejwt
      djangorestframework
      drf-spectacular

      bleach
      cryptography
      distutils
      dulwich
      feedparser
      gunicorn
      jinja2
      pdf2image
      pillow
      pint
      python-barcode
      python-dotenv
      qrcode
      pytz
      pyyaml
      rapidfuzz
      sentry-sdk
      structlog
      tablib
      tinycss2
      weasyprint
      whitenoise
      pypdf
      ppf-datamatrix
      psycopg2
      mysqlclient
      requests-mock

      opentelemetry-api
      opentelemetry-sdk
      opentelemetry-exporter-otlp
      opentelemetry-instrumentation-django
      opentelemetry-instrumentation-requests
      opentelemetry-instrumentation-redis
      opentelemetry-instrumentation-sqlite3
      opentelemetry-instrumentation-system-metrics
      opentelemetry-instrumentation-wsgi
    ]
    ++ tablib.optional-dependencies.all
    ++ tablib.optional-dependencies.xls
    ++ tablib.optional-dependencies.xlsx
    ++ djangorestframework-simplejwt.optional-dependencies.crypto
    ++ django-anymail.optional-dependencies.amazon-ses
    ++ django-allauth.optional-dependencies.socialaccount
    ++ django-allauth.optional-dependencies.saml
    ++ django-allauth.optional-dependencies.openid
    ++ django-allauth.optional-dependencies.mfa;

  build-system = [ python3.pkgs.setuptools ];

  prePatch =
    let
      skippedCheckFunctions = [
        "test_api_call"
        "test_bom_export"
        "test_commit_info"
        "test_date"
        "test_date_filters"
        "test_download_build_orders"
        "test_download_csv"
        "test_download_csv"
        "test_download_image"
        "test_download_line_items"
        "test_download_xlsx"
        "test_export"
        "test_export"
        "test_export"
        "test_full_process"
        "test_function_errors"
        "test_hash"
        "test_import_part"
        "test_large_export"
        "test_model_names"
        "test_package_loading"
        "test_part_download"
        "test_part_label_translation"
        "test_plugin_install"
        "test_rates"
        "test_refresh_endpoint"
        "test_return"
        "test_stocktake_exporter"
        "test_task_check_for_updates"
        "test_users_exist"
        "test_valid_url"
      ];
      skippedFuncScripts = builtins.map (funcName: ''
        grep -rlZ ${funcName} . | while IFS= read -r -d "" file; do
          substituteInPlace "$file" --replace-fail "${funcName}" "skip_${funcName}"
        done
      '') skippedCheckFunctions;
    in
    ''
      ${lib.concatStringsSep "\n" skippedFuncScripts}
    '';

  installPhase =
    let
      pythonPath = python3.pkgs.makePythonPath dependencies;
    in
    ''
      runHook preInstall

      # Don't need to bother with a non-maintained library from ages ago
      substituteInPlace src/backend/InvenTree/InvenTree/settings.py --replace-fail "django_slowtests.testrunner.DiscoverSlowestTestsRunner" "django.test.runner.DiscoverRunner"

      mkdir -p $out/lib/${pname}/src/backend/InvenTree/web/
      cp -r src $out/lib/${pname}
      ln -s ${frontend}/static $out/lib/${pname}/src/backend/InvenTree/web

      chmod +x $out/lib/${pname}/src/backend/InvenTree/manage.py

      makeWrapper $out/lib/${pname}/src/backend/InvenTree/manage.py $out/bin/${pname} \
        --prefix PYTHONPATH : "${pythonPath}:$out/lib/${pname}/src/backend/InvenTree"

      makeWrapper ${lib.getExe python3.pkgs.gunicorn} $out/bin/gunicorn \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python3.sitePackages}":"${pythonPath}:$out/lib/${pname}/src/backend/InvenTree"

      runHook postInstall
    '';
  doCheck = true;
  env = {
    DJANGO_SETTINGS_MODULE = "InvenTree.settings";
  };

  checkPhase = ''
    runHook preCheck

    tmpDir=$(mktemp -d)
    mkdir -p $tmpDir/media
    mkdir -p $tmpDir/.cache/fontconfig
    export HOME=$tmpDir
    export INVENTREE_STATIC_ROOT=$tmpDir
    export INVENTREE_MEDIA_ROOT=$tmpDir/media
    export INVENTREE_BACKUP_DIR=$tmpDir
    export INVENTREE_DB_ENGINE=django.db.backends.sqlite3
    export INVENTREE_DB_NAME=inventree.db
    export INVENTREE_SITE_URL="http://localhost:8000"

    export INVENTREE_PLUGINS_ENABLED=true
    export INVENTREE_PLUGIN_TESTING=true
    export INVENTREE_PLUGIN_TESTING_SETUP=true

    pushd src/backend/InvenTree
    ${python3.interpreter} ./manage.py check
    ${python3.interpreter} ./manage.py migrate

    ${python3.interpreter} ./manage.py test --failfast
    popd

    runHook postCheck
  '';

  nativeCheckInputs = with python3.pkgs; [
    django-test-migrations
    pytest-django
    pytest-env
    pytestCheckHook
    invoke
    coverage
    pytest-cov
    pdfminer-six
  ];
  passthru =
    let
      pythonPath = python3.pkgs.makePythonPath dependencies;
    in
    {
      inherit frontend;
      pythonPath = pythonPath;
    };

  meta = {
    description = "Open Source Inventory Management System";
    homepage = "https://inventree.org/";
    changelog = "https://github.com/paperless-ngx/paperless-ngx/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "inventree";
    maintainers = with lib.maintainers; [
      kurogeek
    ];
  };
}
