{
  stdenv,
  lib,
  python3Packages,
  fetchFromGitHub,
  nixosTests,
  fetchYarnDeps,
  python3,
  nodejs,
  yarnBuildHook,
  yarnConfigHook,
}:
let
  version = "4.5.0";
  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "docs";
    tag = "v${version}";
    hash = "sha256-/mI11ldbYa051WA2hkV7fnc8CJOb0jHra0FJ+eVCqVs=";
  };

  mail-templates = stdenv.mkDerivation {
    name = "lasuite-docs-${version}-mjml";
    inherit src;

    sourceRoot = "source/src/mail";

    env.DOCS_DIR_MAILS = "${placeholder "out"}";

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/src/mail/yarn.lock";
      hash = "sha256-g71OGg0PAo60h0bC+oOyvLvPOCg0pYXuYD8vsR5X9/k=";
    };

    nativeBuildInputs = [
      nodejs
      yarnConfigHook
      yarnBuildHook
    ];

    dontInstall = true;
  };
in

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lasuite-docs";
  pyproject = true;
  inherit version src;

  sourceRoot = "source/src/backend";

  patches = [
    # Support configuration throught environment variables for SECURE_*
    ./secure_settings.patch

    # Fix creation of unsafe C function in postgresql migrations
    ./postgresql_fix.patch
  ];

  # Otherwise fails with:
  # socket.gaierror: [Errno 8] nodename nor servname provided, or not known
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace impress/settings.py \
      --replace-fail \
        "gethostname()" \
        "gethostname() + '.local'"
  '';
  __darwinAllowLocalNetworking = true;

  build-system = with python3Packages; [ setuptools ];

  dependencies =
    with python3Packages;
    [
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
      langfuse
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
    ]
    ++ celery.optional-dependencies.redis
    ++ django-lasuite.optional-dependencies.all
    ++ django-storages.optional-dependencies.s3;

  pythonRelaxDeps = true;

  postBuild = ''
    export DATA_DIR=$(pwd)/data
    ${python3.pythonOnBuildForHost.interpreter} manage.py collectstatic --no-input --clear
  '';

  postInstall =
    let
      pythonPath = python3Packages.makePythonPath finalAttrs.passthru.dependencies;
    in
    ''
      mkdir -p $out/{bin,share}

      cp ./manage.py $out/bin/.manage.py
      cp -r data/static $out/share
      chmod +x $out/bin/.manage.py

      makeWrapper $out/bin/.manage.py $out/bin/docs \
        --prefix PYTHONPATH : "${pythonPath}"
      makeWrapper ${lib.getExe python3Packages.celery} $out/bin/celery \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python3.sitePackages}"
      makeWrapper ${lib.getExe python3Packages.gunicorn} $out/bin/gunicorn \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python3.sitePackages}"

      mkdir -p $out/${python3.sitePackages}/core/templates
      ln -sv ${mail-templates}/ $out/${python3.sitePackages}/core/templates/mail
    '';

  passthru.tests = {
    login-and-create-doc = nixosTests.lasuite-docs;
  };

  meta = {
    description = "Collaborative note taking, wiki and documentation platform that scales. Built with Django and React. Opensource alternative to Notion or Outline";
    homepage = "https://github.com/suitenumerique/docs";
    changelog = "https://github.com/suitenumerique/docs/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    mainProgram = "docs";
    platforms = lib.platforms.all;
  };
})
