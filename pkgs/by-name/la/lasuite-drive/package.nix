{
  lib,
  python3,
  stdenv,
  fetchYarnDeps,
  fetchFromGitHub,
  nodejs,
  yarnConfigHook,
  yarnBuildHook,
}:
let
  version = "0.17.0";
  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "drive";
    tag = "v${version}";
    hash = "sha256-GaJUsfH43HNVGwJqNGTpvIm4MbKJYTN0ZHT7ehWk4aQ=";
  };

  mail-templates = stdenv.mkDerivation {
    name = "lasuite-docs-${version}-mjml";
    inherit src;

    sourceRoot = "source/src/mail";

    env.DIR_MAILS = "${placeholder "out"}";

    postPatch = ''
      sed -i 's|DIR_MAILS=.*||' bin/html-to-plain-text
      sed -i 's|DIR_MAILS=.*||' bin/mjml-to-html
    '';

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/src/mail/yarn.lock";
      hash = "sha256-UPIb9QJk+zC8wYeBeDnmlGLhHDhsEOoT+qquFM1XyqU=";
    };

    nativeBuildInputs = [
      nodejs
      yarnConfigHook
      yarnBuildHook
    ];

    dontInstall = true;

    __structuredAttrs = true;
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "lasuite-drive";
  pyproject = true;
  inherit version src;

  sourceRoot = "source/src/backend";

  patches = [
    # Support configuration throught environment variables for SECURE_*
    ./secure_settings.patch
    # Support OIDC PKCE fields
    # https://github.com/suitenumerique/drive/pull/691
    ./pkce_settings.patch
  ];

  build-system = with python3.pkgs; [ uv-build ];

  dependencies =
    with python3.pkgs;
    [
      boto3
      brotli
      celery
      defusedxml
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
      django-pydantic-field
      django-redis
      django-storages
      django-timezone-field
      djangorestframework
      djangorestframework-api-key
      dockerflow
      drf-spectacular
      drf-spectacular-sidecar
      drf-standardized-errors
      easy-thumbnails
      factory-boy
      gunicorn
      jsonschema
      markdown
      mozilla-django-oidc
      nested-multipart-parser
      posthog
      psycopg
      pydantic
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

  postPatch = ''
    mkdir data
    mv assets data

    # Use non-versioned uv_build and include all sub-packages
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.10.7,<0.11.0' 'uv_build' \
      --replace-fail 'module-root = ""' 'module-root = ""
      module-name = ["core", "demo", "drive", "e2e", "wopi"]
      data = ["data"]
      namespace = true'
  '';

  postBuild = ''
    export DATA_DIR=$(pwd)/data
    ${python3.pythonOnBuildForHost.interpreter} manage.py collectstatic --no-input --clear
  '';

  postInstall =
    let
      pythonPath = python3.pkgs.makePythonPath dependencies;
    in
    ''
      mkdir -p $out/{bin,share}
      cp ./manage.py $out/bin/.manage.py
      cp -r data/static $out/share
      chmod +x $out/bin/.manage.py
      makeWrapper $out/bin/.manage.py $out/bin/drive \
        --prefix PYTHONPATH : "${pythonPath}"
      makeWrapper ${lib.getExe python3.pkgs.celery} $out/bin/celery \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python3.sitePackages}"
      makeWrapper ${lib.getExe python3.pkgs.gunicorn} $out/bin/gunicorn \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python3.sitePackages}"

      mkdir -p $out/${python3.sitePackages}/core/templates
      ln -sv ${mail-templates}/ $out/${python3.sitePackages}/core/templates/mail
    '';

  __structuredAttrs = true;

  meta = {
    description = "A collaborative file sharing and document management platform that scales. Built with Django and React. Opensource alternative to Sharepoint or Google Drive";
    homepage = "https://github.com/suitenumerique/drive";
    changelog = "https://github.com/suitenumerique/drive/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    mainProgram = "drive";
    platforms = lib.platforms.all;
  };
}
