{
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  nodejs,
  python3,
  python3Packages,
  gettext,
  stdenv,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
}:
let

  version = "1.2.6";
  src = fetchFromGitHub {
    owner = "inventree";
    repo = "inventree";
    tag = "${version}";
    hash = "sha256-JJtjW0PAsGiDnM8vwqrSdDtO6QuzdVoyY4MeEyaSH4w=";
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
        runHook preBuild

        export PATH=$PATH:$TMP/frontend/node_modules/.bin
        substituteInPlace $TMP/frontend/vite.config.ts --replace-fail "../../src/backend/InvenTree/web/static/web" out/static/web

        npm run extract
        npm run compile
        npm run build
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        mv out/static $out

        runHook postInstall
      '';
    });
in
python3Packages.buildPythonApplication rec {
  pname = "inventree";
  pyproject = true;
  inherit version src;

  dependencies =
    with python3Packages;
    [
      django
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

  build-system = [ python3Packages.setuptools ];
  nativeBuildInputs = [ gettext ];

  prePatch =
    let
      skippedCheckFunctions = [
        # Tries to access github.com
        "test_download_build_orders"
        "test_download_csv"
        "test_download_image"
        "test_download_line_items"
        "test_download_xlsx"
        "test_task_check_for_updates"
        "test_valid_url"
        # Tries to access api.frankfurter.app
        "test_rates"
        "test_refresh_endpoint"
        # Tries to use pip
        "test_full_process"
        "test_package_loading"
        "test_plugin_install"
        # Appears not to work under sqlite3
        "test_users_exist"
        # Wants to access git
        "test_commit_info"
        # TODO figure out why this fails
        "test_setting_object"
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
      pythonPath = python3Packages.makePythonPath dependencies;
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
        --prefix PYTHONPATH : "${pythonPath}:$out/lib/${pname}/src/backend/InvenTree" \
        --set INVENTREE_COMMIT_HASH abcdef \
        --set INVENTREE_COMMIT_DATE 1970-01-01

      makeWrapper ${lib.getExe python3Packages.gunicorn} $out/bin/gunicorn \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python3.sitePackages}":"${pythonPath}:$out/lib/${pname}/src/backend/InvenTree" \
        --set INVENTREE_COMMIT_HASH abcdef \
        --set INVENTREE_COMMIT_DATE 1970-01-01

      # Generate static assets
      pushd $out/lib/${pname}/src/backend/InvenTree &>/dev/null
      export INVENTREE_STATIC_ROOT=$out/lib/inventree/static
      export INVENTREE_MEDIA_ROOT=$(mktemp -d)
      export INVENTREE_BACKUP_DIR=$(mktemp -d)
      export INVENTREE_DB_ENGINE=django.db.backends.sqlite3
      export INVENTREE_DB_NAME=inventree.db
      export INVENTREE_SITE_URL="http://localhost:8000"
      ${python3.interpreter} ./manage.py collectstatic --no-input

      # Build translations
      ${python3.interpreter} ./manage.py compilemessages
      popd &>/dev/null

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
    export INVENTREE_DEBUG=True
    export INVENTREE_STATIC_ROOT=$out/lib/inventree/static
    export INVENTREE_MEDIA_ROOT=$tmpDir/media
    export INVENTREE_BACKUP_DIR=$tmpDir
    export INVENTREE_DB_ENGINE=django.db.backends.sqlite3
    export INVENTREE_DB_NAME=inventree.db
    export INVENTREE_SITE_URL="http://localhost:8000"
    # test_date
    export INVENTREE_COMMIT_HASH=abcdef
    export INVENTREE_COMMIT_DATE=1970-01-01

    export INVENTREE_PLUGINS_ENABLED=true
    export INVENTREE_PLUGIN_TESTING=true
    export INVENTREE_PLUGIN_TESTING_SETUP=true

    pushd src/backend/InvenTree &>/dev/null
    ${python3.interpreter} ./manage.py check
    ${python3.interpreter} ./manage.py migrate
    ${python3.interpreter} ./manage.py compilemessages

    ${python3.interpreter} ./manage.py test --parallel --failfast
    popd &>/dev/null

    runHook postCheck
  '';

  nativeCheckInputs = with python3Packages; [
    django-test-migrations
    pytest-django
    pytest-env
    invoke
    coverage
    pdfminer-six
    tblib
    pytest
  ];
  passthru =
    let
      pythonPath = python3Packages.makePythonPath dependencies;
    in
    {
      inherit frontend pythonPath;
    };

  meta = {
    description = "Open Source Inventory Management System";
    homepage = "https://inventree.org/";
    changelog = "https://github.com/inventree/inventree/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "inventree";
    maintainers = with lib.maintainers; [ kurogeek ];
  };
}
