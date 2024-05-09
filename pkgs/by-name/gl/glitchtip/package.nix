{ lib
, python3
, fetchFromGitLab
, uwsgi
, stdenv
, callPackage
}:
let
  pythonPackages = with python3.pkgs; [
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

in
stdenv.mkDerivation rec {
  pname = "glitchtip";
  version = "4.0.8";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-backend";
    rev = "v${version}";
    hash = "sha256-WNB7znUx9OwCSwxz06EghsK47bPEtrMXUYLlw7bVCn4=";
  };

  nativeBuildInputs = [
    python3
  ] ++ pythonPackages;

  dependencies = [
    (uwsgi.override { plugins = [ "python3" ]; })
  ] ++ pythonPackages;

  passthru.pythonPackages = pythonPackages;
  passthru.frontend = callPackage ./frontend.nix { inherit meta; };

  buildPhase = ''
    runHook preBuild

    ln -s ${passthru.frontend} dist
    python3 manage.py collectstatic

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp -r . $out/

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
