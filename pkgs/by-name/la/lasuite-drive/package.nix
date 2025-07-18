{
  lib,
  python3,
  fetchFromGitHub,
}:
let
  python = python3.override {
    self = python3;
    packageOverrides = self: super: { django = super.django_5; };
  };
in

python.pkgs.buildPythonApplication rec {
  pname = "lasuite-drive";
  version = "unstable-2025-06-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "drive";
    rev = "fd36f04c5b604977989327b3ee675a77f28ecd9f";
    hash = "sha256-RXGqlcqFkulGVdEyIosZhyGmcxwMDWFdT6q6P5QFxXs=";
  };

  sourceRoot = "source/src/backend";

  patches = [
    # Support for $ENVIRONMENT_VARIABLE_FILE to be able to pass secret files
    # See: https://github.com/suitenumerique/drive/pull/196
    ./environment_variables.patch
    # Support configuration throught environment variables for SECURE_*
    ./secure_settings.patch
  ];

  build-system = with python.pkgs; [ setuptools ];

  dependencies =
    with python.pkgs;
    [
      boto3
      brotli
      celery
      dj-database-url
      django
      django-configurations
      django-cors-headers
      django-countries
      django-debug-toolbar
      django-extensions
      django-filter
      django-lasuite
      django-ltree
      django-parler
      django-redis
      django-storages
      django-timezone-field
      djangorestframework
      drf-spectacular
      drf-spectacular-sidecar
      drf-standardized-errors
      dockerflow
      easy-thumbnails
      factory-boy
      gunicorn
      jsonschema
      markdown
      mozilla-django-oidc
      nested-multipart-parser
      posthog
      psycopg
      pyjwt
      python-magic
      redis
      requests
      sentry-sdk
      url-normalize
      whitenoise
    ]
    ++ celery.optional-dependencies.redis
    ++ django-storages.optional-dependencies.s3;

  pythonRelaxDeps = true;

  postBuild = ''
    export DATA_DIR=$(pwd)/data
    ${python.pythonOnBuildForHost.interpreter} manage.py collectstatic --no-input --clear
  '';

  postInstall =
    let
      pythonPath = python.pkgs.makePythonPath dependencies;
    in
    ''
      mkdir -p $out/{bin,share}
      cp ./manage.py $out/bin/.manage.py
      cp -r data/static $out/share
      chmod +x $out/bin/.manage.py
      makeWrapper $out/bin/.manage.py $out/bin/drive \
        --prefix PYTHONPATH : "${pythonPath}"
      makeWrapper ${lib.getExe python.pkgs.celery} $out/bin/celery \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python.sitePackages}"
      makeWrapper ${lib.getExe python.pkgs.gunicorn} $out/bin/gunicorn \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python.sitePackages}"
    '';

  meta = {
    description = "A collaborative file sharing and document management platform that scales. Built with Django and React. Opensource alternative to Sharepoint or Google Drive";
    homepage = "https://github.com/suitenumerique/drive";
    changelog = "https://github.com/suitenumerique/drive/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    mainProgram = "drive";
    platforms = lib.platforms.all;
  };
}
