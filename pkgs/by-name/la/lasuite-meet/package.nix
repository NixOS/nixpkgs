{
  callPackage,
  lib,
  fetchFromGitHub,
  nixosTests,
  python3,
  stdenv,
}:
let
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "meet";
    tag = "v${version}";
    hash = "sha256-18DcrrEvqWR6caEVZYxQlSnKcxItEpNE+bMhtS4Aa0M=";
  };

  meta = {
    homepage = "https://github.com/suitenumerique/meet";
    changelog = "https://github.com/suitenumerique/meet/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };

  mail = callPackage ./mail.nix { inherit src version meta; };
  frontend = callPackage ./frontend.nix { inherit src version meta; };
  outlook = callPackage ./addon-outlook.nix { inherit src version meta; };

  python = python3.override {
    self = python3;
    packageOverrides = (self: super: { django = super.django_5; });
  };
in
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "lasuite-meet";
  pyproject = true;
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/src/backend";

  patches = [
    # Support configuration throught environment variables for SECURE_*
    ./secure_settings.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.10.9,<0.11.0" "uv_build"
  ''
  # Otherwise fails with:
  # socket.gaierror: [Errno 8] nodename nor servname provided, or not known
  + (lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace impress/settings.py \
      --replace-fail \
        "gethostname()" \
        "gethostname() + '.local'"
  '');
  __darwinAllowLocalNetworking = true;

  build-system = with python.pkgs; [ uv-build ];

  dependencies =
    with python.pkgs;
    [
      aiohttp
      boto3
      brevo-python
      brotli
      celery
      dj-database-url
      django
      django-configurations
      django-cors-headers
      django-countries
      django-extensions
      django-filter
      django-lasuite
      django-parler
      django-pydantic-field
      django-redis
      django-storages
      django-timezone-field
      djangorestframework
      dockerflow
      drf-spectacular
      drf-spectacular-sidecar
      easy-thumbnails
      factory-boy
      gunicorn
      jsonschema
      june-analytics-python
      livekit-api
      markdown
      mozilla-django-oidc
      nested-multipart-parser
      psycopg
      pydantic
      pyjwt
      pyopenssl
      python-frontmatter
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
    export DJANGO_DATA_DIR=$(pwd)/data
    ${python.pythonOnBuildForHost.interpreter} manage.py collectstatic --noinput --clear
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

      makeWrapper $out/bin/.manage.py $out/bin/meet \
        --prefix PYTHONPATH : "${pythonPath}"
      makeWrapper ${lib.getExe python.pkgs.celery} $out/bin/celery \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python.sitePackages}"
      makeWrapper ${lib.getExe python.pkgs.gunicorn} $out/bin/gunicorn \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python.sitePackages}"

      mkdir -p $out/${python.sitePackages}/core/templates
      ln -sv ${finalAttrs.passthru.mail}/ $out/${python.sitePackages}/core/templates/mail
    '';

  passthru = {
    inherit mail frontend;
    addons = {
      inherit outlook;
    };
    tests = {
      login-and-create-room = nixosTests.lasuite-meet;
    };
  };

  meta = meta // {
    description = "Open source alternative to Google Meet and Zoom powered by LiveKit: HD video calls, screen sharing, and chat features. Built with Django and React";
    mainProgram = "meet";
  };
})
