{
  lib,
  python313,
  fetchFromGitLab,
  callPackage,
  stdenv,
  makeWrapper,
  nixosTests,
}:

let
  python = python313.override {
    packageOverrides = final: prev: {
      django = final.django_5;
      django-extensions = prev.django-extensions.overridePythonAttrs { doCheck = false; };
    };
  };

  pythonPackages =
    with python.pkgs;
    [
      aiohttp
      anonymizeip
      boto3
      brotli
      celery
      celery-batches
      dj-stripe
      django
      django-allauth
      django-anymail
      django-cors-headers
      django-csp
      django-environ
      django-extensions
      django-import-export
      django-ipware
      django-ninja
      django-organizations
      django-prometheus
      django-redis
      django-sql-utils
      django-storages
      google-cloud-logging
      gunicorn
      orjson
      psycopg
      pydantic
      sentry-sdk
      symbolic
      user-agents
      uvicorn
      uwsgi-chunked
      whitenoise
    ]
    ++ celery.optional-dependencies.redis
    ++ django-allauth.optional-dependencies.mfa
    ++ django-allauth.optional-dependencies.socialaccount
    ++ django-redis.optional-dependencies.hiredis
    ++ django-storages.optional-dependencies.boto3
    ++ django-storages.optional-dependencies.azure
    ++ django-storages.optional-dependencies.google
    ++ psycopg.optional-dependencies.c
    ++ psycopg.optional-dependencies.pool
    ++ pydantic.optional-dependencies.email;

  frontend = callPackage ./frontend.nix { };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "glitchtip";
  version = "4.2.5";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-backend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OTf2rvx+ONnB7pLB7rinztXL7l2eZfIuI7PosCXaOH8=";
  };

  propagatedBuildInputs = pythonPackages;

  nativeBuildInputs = [
    makeWrapper
    python
  ];

  buildPhase = ''
    runHook preBuild

    export DEBUG=0
    export DEBUG_TOOLBAR=0

    ln -s ${finalAttrs.passthru.frontend} dist
    python3 manage.py collectstatic

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r . $out/lib/glitchtip
    chmod +x $out/lib/glitchtip/manage.py
    makeWrapper $out/lib/glitchtip/manage.py $out/bin/glitchtip-manage \
      --prefix PYTHONPATH : "$PYTHONPATH"

    runHook postInstall
  '';

  passthru = {
    inherit frontend python;
    tests = { inherit (nixosTests) glitchtip; };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Open source Sentry API compatible error tracking platform";
    homepage = "https://glitchtip.com";
    changelog = "https://gitlab.com/glitchtip/glitchtip-backend/-/blob/v${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      defelo
      felbinger
    ];
    mainProgram = "glitchtip-manage";
  };
})
