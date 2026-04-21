{
  lib,
  python314,
  fetchFromGitLab,
  callPackage,
  stdenv,
  makeWrapper,
  nixosTests,
}:

let
  python = python314.override {
    self = python;
    packageOverrides = final: prev: {
      django = final.django_6;
    };
  };

  pythonPackages =
    with python.pkgs;
    [
      aiohttp
      anonymizeip
      arro3-core
      arro3-io
      boto3
      brotli
      cxxfilt
      django
      django-allauth
      django-anymail
      django-cors-headers
      django-environ
      django-extensions
      django-import-export
      django-ipware
      django-ninja
      django-ninja-cursor-pagination
      django-organizations
      django-postgres-partition
      django-prometheus
      django-storages
      django-vcache
      django-vtasks
      duckdb
      google-cloud-logging
      granian
      mcp
      minidump
      orjson
      psycopg
      pydantic
      sentry-sdk
      symbolic
      user-agents
      uuid6
      uwsgi-chunked
      whitenoise
    ]
    ++ django-allauth.optional-dependencies.headless-spec
    ++ django-allauth.optional-dependencies.mfa
    ++ django-allauth.optional-dependencies.socialaccount
    ++ django-storages.optional-dependencies.boto3
    ++ django-storages.optional-dependencies.azure
    ++ django-storages.optional-dependencies.google
    ++ django-vtasks.optional-dependencies.valkey
    ++ granian.optional-dependencies.reload
    ++ granian.optional-dependencies.uvloop
    ++ mcp.optional-dependencies.cli
    ++ psycopg.optional-dependencies.c
    ++ psycopg.optional-dependencies.pool
    ++ pydantic.optional-dependencies.email;

  frontend = callPackage ./frontend.nix { };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "glitchtip";
  version = "6.1.6";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-backend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BUWLN3+ob934MgIoDLirY0O8fn6G3zmGA5wuVGPPp7w=";
  };

  postPatch = ''
    echo 'import os
    ALLAUTH_TRUSTED_CLIENT_IP_HEADER = os.getenv(
        "ALLAUTH_TRUSTED_CLIENT_IP_HEADER",
        None
    )' >> glitchtip/settings.py
  '';

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
