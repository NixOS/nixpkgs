{
  lib,
  python3,
  fetchFromGitHub,
  nixosTests,
  fetchPypi,
}:
let
  python = python3.override {
    self = python3;
    packageOverrides = self: super: {
      django = super.django_5_2;
      django-csp = super.django-csp.overridePythonAttrs rec {
        version = "4.0";
        src = fetchPypi {
          inherit version;
          pname = "django_csp";
          hash = "sha256-snAQu3Ausgo9rTKReN8rYaK4LTOLcPvcE8OjvShxKDM=";
        };
      };
    };
  };
in

python.pkgs.buildPythonApplication rec {
  pname = "lasuite-docs";
  version = "3.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "docs";
    tag = "v${version}";
    hash = "sha256-uo49y+tJXdc8gfFIHSIEk0DEowMsHWA64IxlHpFHUTU=";
  };

  sourceRoot = "source/src/backend";

  patches = [
    # Support configuration throught environment variables for SECURE_*
    ./secure_settings.patch
  ];

  build-system = with python.pkgs; [ setuptools ];

  dependencies = with python.pkgs; [
    beautifulsoup4
    boto3
    celery
    django
    django-configurations
    django-cors-headers
    django-countries
    django-csp
    django-extensions
    django-filter
    django-lasuite
    django-parler
    django-redis
    django-storages
    django-timezone-field
    django-treebeard
    djangorestframework
    drf-spectacular
    drf-spectacular-sidecar
    dockerflow
    easy-thumbnails
    factory-boy
    gunicorn
    jsonschema
    lxml
    markdown
    mozilla-django-oidc
    nested-multipart-parser
    openai
    psycopg
    pycrdt
    pyjwt
    pyopenssl
    python-magic
    redis
    requests
    sentry-sdk
    whitenoise
  ];

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

      makeWrapper $out/bin/.manage.py $out/bin/docs \
        --prefix PYTHONPATH : "${pythonPath}"
      makeWrapper ${lib.getExe python.pkgs.celery} $out/bin/celery \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python.sitePackages}"
      makeWrapper ${lib.getExe python.pkgs.gunicorn} $out/bin/gunicorn \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python.sitePackages}"
    '';

  passthru.tests = {
    login-and-create-doc = nixosTests.lasuite-docs;
  };

  meta = {
    description = "Collaborative note taking, wiki and documentation platform that scales. Built with Django and React. Opensource alternative to Notion or Outline";
    homepage = "https://github.com/suitenumerique/docs";
    changelog = "https://github.com/suitenumerique/docs/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    mainProgram = "docs";
    platforms = lib.platforms.all;
  };
}
