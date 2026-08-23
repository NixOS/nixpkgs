{
  stdenv,
  lib,
  python3Packages,
  fetchFromGitHub,
  makeWrapper,
  gdal,
  geos,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_11,
  nodejs,
  postgresql,
  postgresqlTestHook,
  playwright-driver,
}:
let
  pnpm = pnpm_11;

  python = python3Packages.python.override {
    packageOverrides = self: super: {
      django_5 = super.django_5.override { withGdal = true; };
      django = super.django_5;

      django-oauth-toolkit = super.django-oauth-toolkit.overrideAttrs (old: {
        version = "3.3.0";

        src = old.src.override {
          hash = "sha256-eRQzAFUvSgoDiP7LW/+hMrNxHuXVxY+wc/E3VU/zeXo=";
        };
      });

      # custom python module part of froide
      dogtail = super.buildPythonPackage {
        pname = "dogtail";
        version = "0-unstable-2024-11-27";
        pyproject = true;

        src = fetchFromGitHub {
          owner = "okfde";
          repo = "dogtail";
          rev = "d2f341cab0f05ef4e193f0158fe5a64aadc5bae6";
          hash = "sha256-2lQZgvFXAz6q/3NpBcwckUologWxKmwXI0ZG5nylajg=";
        };

        build-system = with super; [ setuptools ];
      };
    };
  };

in
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "froide";
  version = "0-unstable-2026-08-19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "okfde";
    repo = "froide";
    rev = "a83f2c28e96f15c55f3009cdadbf2a8fcf17fda8";
    hash = "sha256-hC/CfKh8PTuDiB8PvjdpbOjEVLwVGyR4lxBBcm9vcRg=";
  };

  patches = [ ./django_42_storages.patch ];

  build-system = [ python.pkgs.setuptools ];

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpmConfigHook
    pnpm
  ];

  dependencies = with python.pkgs; [
    celery
    celery-singleton
    channels
    dj-database-url
    django
    django-celery-beat
    django-celery-email
    django-configurations
    django-contrib-comments
    django-crossdomainmedia
    django-elasticsearch-dsl
    django-extended-makemessages
    django-filingcabinet
    django-filter
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
    nh3
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

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    fetcherVersion = 4;
    hash = "sha256-+ywpcwF4H2s6s+ls71S+sy6l3gikz62haXCBuI4z+f4=";
  };

  postBuild = ''
    pnpm run build
  '';

  postInstall = ''
    cp -r build manage.py $out/${python.sitePackages}/froide/
    makeWrapper $out/${python.sitePackages}/froide/manage.py $out/bin/froide \
      --prefix PYTHONPATH : "${python3Packages.makePythonPath finalAttrs.passthru.dependencies}" \
      --set GDAL_LIBRARY_PATH "${gdal}/lib/libgdal.so" \
      --set GEOS_LIBRARY_PATH "${geos}/lib/libgeos_c.so"
  '';

  nativeCheckInputs = with python.pkgs; [
    (postgresql.withPackages (p: [ p.postgis ]))
    postgresqlTestHook
    pytest-django
    pytest-playwright
    pytest-xdist
    pytestCheckHook
  ];

  checkInputs = with python.pkgs; [
    beautifulsoup4
    pytest-asyncio
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
    # Test hangs
    "test_collapsed_menu"
    "test_make_request_logged_out_with_existing_account"
    # Requires live Elasticsearch on localhost:9200
    "test_campaign_request_match_live"
    "test_make_request_submit_multiple_times"
    "test_edit_request_boilerplate"
    "test_skip_search_similar"
    "test_list_hide_project_duplicates_filter"
    # pytest-asyncio/pytest-playwright event-loop
    # incompatibility on Python 3.14 (RuntimeError: Runner.run()
    "test_redaction"
    # redaction regex doesn't match
    # German "/anfrage/" URL path segment, only "/request/" and "/r/"
    "test_redaction_urls"
    # migration bug — changing LANGUAGES/LANGUAGE_CODE
    # triggers an unwanted migration on foilawtranslation's unique
    "test_no_migration_needed_when_languages_change"
  ];

  preCheck = ''
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

  passthru = {
    inherit python;
  };

  meta = {
    description = "Freedom of Information Portal";
    homepage = "https://github.com/okfde/froide";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
    mainProgram = "froide";
  };
})
