{
  lib,
  python313,
  fetchFromGitLab,
  fetchFromGitHub,
  fetchPypi,
  rustPlatform,
  callPackage,
  stdenv,
  makeWrapper,
  nixosTests,
}:

let
  python = python313.override {
    self = python;
    packageOverrides = final: prev: {
      django = final.django_5_2;
      django-csp = prev.django-csp.overridePythonAttrs rec {
        version = "4.0";
        src = fetchPypi {
          inherit version;
          pname = "django_csp";
          hash = "sha256-snAQu3Ausgo9rTKReN8rYaK4LTOLcPvcE8OjvShxKDM=";
        };
      };
      django-ninja-cursor-pagination = prev.django-ninja-cursor-pagination.overridePythonAttrs {
        # checks are failing with django 5
        doCheck = false;
      };
      symbolic = prev.symbolic.overridePythonAttrs rec {
        version = "10.2.1";
        src = fetchFromGitHub {
          owner = "getsentry";
          repo = "symbolic";
          tag = version;
          hash = "sha256-3u4MTzaMwryGpFowrAM/MJOmnU8M+Q1/0UtALJib+9A=";
          # the `py` directory is not included in the tarball, so we fetch the source via git instead
          forceFetchGit = true;
        };
        cargoDeps = rustPlatform.fetchCargoVendor {
          inherit src postPatch;
          hash = "sha256-cpIVzgcxKfEA5oov6/OaXqknYsYZUoduLTn2qIXGL5U=";
        };
        postPatch = ''
          ln -s ${./symbolic_Cargo.lock} Cargo.lock
        '';
      };
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
      django-ninja-cursor-pagination
      django-organizations
      django-postgres-partition
      django-prometheus
      django-redis
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
  version = "5.0.5";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-backend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7ulmrFOy14/Y/8LmKrmBzqrMPuwfdWOGMuhhhYI7+f4=";
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
