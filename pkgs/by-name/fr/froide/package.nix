{
  stdenv,
  lib,
  python3Packages,
  fetchFromGitHub,
  makeWrapper,
  gdal,
  geos,
  pnpm,
  nodejs,
  postgresql,
  postgresqlTestHook,
  playwright-driver,
}:
let

  python = python3Packages.python.override {
    packageOverrides = self: super: { django = super.django.override { withGdal = true; }; };
  };

in
python.pkgs.buildPythonApplication rec {
  pname = "froide";
  version = "0-unstable-2025-04-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "okfde";
    repo = "froide";
    rev = "9e4838fc5f17a0506af42ad5fd1ebc66cff4b92a";
    hash = "sha256-0EC6oCaiK7gw5ikemskiK3qOlflGHzlG4giDQNj9tBQ=";
  };

  patches = [ ./django_42_storages.patch ];

  # Relax dependency pinning
  # Channels: https://github.com/okfde/froide/issues/995
  pythonRelaxDeps = [
    "channels"
  ];

  build-system = [ python.pkgs.setuptools ];

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm.configHook
  ];

  dependencies = with python.pkgs; [
    bleach
    celery
    celery-singleton
    channels
    coreapi
    dj-database-url
    django
    django-celery-beat
    django-celery-email
    django-configurations
    django-contrib-comments
    django-crossdomainmedia
    django-elasticsearch-dsl
    django-filingcabinet
    django-filter
    # Project discontinued upstream
    # https://github.com/okfde/froide/issues/893
    django-fsm
    django-json-widget
    django-leaflet
    django-mfa3
    django-oauth-toolkit
    django-parler
    django-storages
    django-taggit
    django-treebeard
    djangorestframework
    djangorestframework-csv
    djangorestframework-jsonp
    dogtail
    drf-spectacular
    drf-spectacular-sidecar
    easy-thumbnails
    elasticsearch
    elasticsearch-dsl
    geoip2
    icalendar
    markdown
    phonenumbers
    pillow
    pikepdf
    psycopg
    pygtail
    pyisemail
    pypdf
    python-magic
    python-mimeparse
    python-slugify
    requests
    wand
    weasyprint
    websockets
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-IeuQoiI/r9AKLZgKkZx0C+qE9ueWuC39Y77MB08zSAc=";
  };

  postBuild = ''
    pnpm run build
  '';

  postInstall = ''
    cp -r build manage.py $out/${python.sitePackages}/froide/
    makeWrapper $out/${python.sitePackages}/froide/manage.py $out/bin/froide \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --set GDAL_LIBRARY_PATH "${gdal}/lib/libgdal.so" \
      --set GEOS_LIBRARY_PATH "${geos}/lib/libgeos_c.so"
  '';

  nativeCheckInputs = with python.pkgs; [
    (postgresql.withPackages (p: [ p.postgis ]))
    postgresqlTestHook
    pytest-django
    pytest-playwright
    pytestCheckHook
  ];

  checkInputs = with python.pkgs; [
    beautifulsoup4
    pytest-factoryboy
    time-machine
  ];

  disabledTests = [
    # Requires network connection: elastic_transport.ConnectionError
    "test_search_similar"
    "test_search"
    "test_list_requests"
    "test_list_jurisdiction_requests"
    "test_tagged_requests"
    "test_publicbody_requests"
    "test_feed"
    "test_request_list_filter_pagination"
    "test_request_list_path_filter"
    "test_web_page"
    "test_autocomplete"
    "test_list_no_identical"
    "test_set_status"
    "test_make_not_logged_in_request"
    "test_make_logged_in_request"
    # TypeError: Pygtail.with_offsets() got an unexpected keyword argument
    "test_email_signal"
    "test_pygtail_log_append"
    "test_bouncing_email"
    "test_multiple_partial"
    "test_logfile_rotation"
  ];

  preCheck =
    ''
      export PGUSER="froide"
      export postgresqlEnableTCP=1
      export postgresqlTestUserOptions="LOGIN SUPERUSER"
      export GDAL_LIBRARY_PATH="${gdal}/lib/libgdal.so"
      export GEOS_LIBRARY_PATH="${geos}/lib/libgeos_c.so"
    ''
    + lib.optionalString (!stdenv.hostPlatform.isRiscV) ''
      export PLAYWRIGHT_BROWSERS_PATH="${playwright-driver.browsers}"
    '';

  # Playwright tests not supported on RiscV yet
  doCheck = lib.meta.availableOn stdenv.hostPlatform playwright-driver.browsers;

  meta = {
    description = "Freedom of Information Portal";
    homepage = "https://github.com/okfde/froide";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
    mainProgram = "froide";
  };
}
