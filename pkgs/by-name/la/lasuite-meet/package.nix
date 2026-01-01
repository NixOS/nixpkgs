{
  lib,
  python3,
  fetchFromGitHub,
  nixosTests,
}:
let
  python = python3.override {
    self = python3;
    packageOverrides = (self: super: { django = super.django_5_2; });
  };
in

python.pkgs.buildPythonApplication rec {
  pname = "lasuite-meet";
<<<<<<< HEAD
  version = "1.0.1";
=======
  version = "0.1.42";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "meet";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-QtaP0b8Aj//tCS6uo4NJcK+IjyrSBTOZ+/ijG3T3ePE=";
=======
    hash = "sha256-STb4JCEoKgzokIA5mWFqJkFH9mtdnIp8NcopLWYSbwQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sourceRoot = "source/src/backend";

  patches = [
    # Support configuration throught environment variables for SECURE_*
    ./secure_settings.patch
  ];

  build-system = with python.pkgs; [ setuptools ];

<<<<<<< HEAD
  dependencies =
    with python.pkgs;
    [
      aiohttp
      boto3
      brevo-python
      brotli
      celery
      django
      django-configurations
      django-cors-headers
      django-countries
      django-extensions
      django-lasuite
      django-parler
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
      pyjwt
      pyopenssl
      python-frontmatter
      redis
      requests
      sentry-sdk
      whitenoise
    ]
    ++ celery.optional-dependencies.redis
    ++ django-lasuite.optional-dependencies.all
    ++ django-storages.optional-dependencies.s3;
=======
  dependencies = with python.pkgs; [
    aiohttp
    boto3
    brevo-python
    brotli
    celery
    django
    django-configurations
    django-cors-headers
    django-countries
    django-extensions
    django-lasuite
    django-parler
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
    pyjwt
    pyopenssl
    python-frontmatter
    redis
    requests
    sentry-sdk
    whitenoise
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonRelaxDeps = true;

  postBuild = ''
    export DJANGO_DATA_DIR=$(pwd)/data
    ${python.pythonOnBuildForHost.interpreter} manage.py collectstatic --noinput --clear
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

      makeWrapper $out/bin/.manage.py $out/bin/meet \
        --prefix PYTHONPATH : "${pythonPath}"
      makeWrapper ${lib.getExe python.pkgs.celery} $out/bin/celery \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python.sitePackages}"
      makeWrapper ${lib.getExe python.pkgs.gunicorn} $out/bin/gunicorn \
        --prefix PYTHONPATH : "${pythonPath}:$out/${python.sitePackages}"
    '';

  passthru.tests = {
    login-and-create-room = nixosTests.lasuite-meet;
  };

  meta = {
    description = "Open source alternative to Google Meet and Zoom powered by LiveKit: HD video calls, screen sharing, and chat features. Built with Django and React";
    homepage = "https://github.com/suitenumerique/meet";
    changelog = "https://github.com/suitenumerique/meet/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    mainProgram = "meet";
    platforms = lib.platforms.all;
  };
}
