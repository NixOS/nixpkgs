{
  callPackage,
  lib,
  python3,
  stdenv,
  fetchFromGitHub,
  nixosTests,
}:
let
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "drive";
    tag = "v${version}";
    hash = "sha256-JoOHbwZR4salfLB9Gg7kfRMDcDA/Srn8qwUqLAZtsz8=";
  };

  meta = {
    homepage = "https://github.com/suitenumerique/drive";
    changelog = "https://github.com/suitenumerique/drive/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.linux;
  };

  mail = callPackage ./mail.nix { inherit src version meta; };
  frontend = callPackage ./frontend.nix { inherit src version meta; };

  python = python3.override {
    self = python;
    packageOverrides = (self: super: { django = super.django_5; });
  };

in
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "lasuite-drive";
  pyproject = true;
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/src/backend";

  patches = [
    # Support configuration throught environment variables for SECURE_*
    ./secure_settings.patch
    # Fix some build fields on pyproject
    ./pyproject_build.patch
  ];

  build-system = with python.pkgs; [ uv-build ];

  dependencies =
    with python.pkgs;
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
    # Put assets inside a data directory
    # so uv will copy the assets directory
    # entirely
    mkdir data
    mv assets data
  ''
  + (lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace impress/settings.py \
      --replace-fail \
        "gethostname()" \
        "gethostname() + '.local'"
  '');
  __darwinAllowLocalNetworking = true;

  postBuild = ''
    export DATA_DIR=$(pwd)/data
    ${python.pythonOnBuildForHost.interpreter} manage.py collectstatic --no-input --clear
  '';

  postInstall =
    let
      pythonPath = python.pkgs.makePythonPath finalAttrs.passthru.dependencies;
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

      mkdir -p $out/${python.sitePackages}/core/templates
      ln -sv ${mail}/ $out/${python.sitePackages}/core/templates/mail
    '';

  passthru = {
    inherit mail frontend;
    tests = {
      login-upload-and-download-file = nixosTests.lasuite-drive;
    };
  };

  __structuredAttrs = true;

  meta = meta // {
    description = "A collaborative file sharing and document management platform that scales. Built with Django and React. Opensource alternative to Sharepoint or Google Drive";
    mainProgram = "drive";
  };
})
