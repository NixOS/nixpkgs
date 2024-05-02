{ lib
, python311
, fetchFromGitLab
, callPackage
, stdenv
, makeWrapper
}:
let
  pythonPackages = with python311.pkgs; [
    aiohttp
    anonymizeip
    boto3
    celery
    celery-batches
    dj-rest-auth
    dj-stripe
    django
    django-allauth
    django-anymail
    django-cors-headers
    django-csp
    django-environ
    django-extensions
    django-filter
    django-import-export
    django-ipware
    django-ninja
    django-organizations
    django-prometheus
    django-redis
    django-rest-mfa
    django-sql-utils
    django-storages
    djangorestframework
    drf-nested-routers
    google-cloud-logging
    gunicorn
    orjson
    psycopg
    sentry-sdk
    symbolic
    user-agents
    uvicorn
    uwsgi-chunked
    whitenoise
  ];

  frontend = callPackage ./frontend.nix { };

in
stdenv.mkDerivation rec {
  pname = "glitchtip";
  version = "4.0.9";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-backend";
    rev = "v${version}";
    hash = "sha256-6WRJgRKU3cI1wPC5bPN+Vn8TtaNAcr1LlKweWH1aOmM=";
  };

  propagatedBuildInputs = pythonPackages;

  nativeBuildInputs = [ makeWrapper python311 ];

  passthru = {
    inherit frontend;
  };

  buildPhase = ''
    runHook preBuild

    export DEBUG=0
    export DEBUG_TOOLBAR=0

    ln -s ${passthru.frontend} dist
    python3 manage.py collectstatic

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r . $out/lib/glitchtip
    chmod +x $out/lib/glitchtip/manage.py
    makeWrapper $out/lib/glitchtip/manage.py $out/bin/glitchtip \
      --prefix PYTHONPATH : "$PYTHONPATH"

    runHook postInstall
  '';

  meta = {
    description = "Django backend for GlitchTip";
    homepage = "https://glitchtip.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    mainProgram = "glitchtip";
  };
}
