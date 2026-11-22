{
  lib,
  python3,
  callPackage,
  fetchFromGitLab,
  postgresql,
  postgresqlTestHook,
  redisTestHook,
  funkwhale,
  runCommand,

  nixosTests,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "funkwhale";
  version = "2.0.17";
  pyproject = true;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "dev.funkwhale.audio";
    owner = "funkwhale";
    repo = "funkwhale";
    tag = finalAttrs.version;
    hash = "sha256-OOICdc86TspoAeqhiFKk0tTX7n4dki6YMtZk28x5p4Y=";
  };

  sourceRoot = "${finalAttrs.src.name}/api";

  patches = [
    # `unicode-slugify` was removed from nixpkgs.
    # See https://github.com/NixOS/nixpkgs/pull/448893.
    ./replace-unicode-slugify.patch

    ./fix-root-filesystem-tests.patch

    # Fix compatibility with django-allauth >= 65.18 where filter_users_by_username
    # was moved from allauth.account.auth_backends to allauth.account.internal.userkit.
    ./django-allauth-compat.patch
  ];

  build-system = with python3.pkgs; [
    poetry-core
  ];

  # Everything is pinned to specific versions.
  pythonRelaxDeps = true;
  pythonRemoveDeps = [
    # Not used directly.
    "gunicorn"
  ];

  dependencies =
    with python3.pkgs;
    [
      # Django
      dj-rest-auth
      django
      django-allauth
      django-cache-memoize
      django-cacheops
      django-cleanup
      django-cors-headers
      django-debug-toolbar
      django-dynamic-preferences
      django-environ
      django-filter
      django-oauth-toolkit
      django-redis
      django-silk
      django-storages
      django-versatileimagefield
      djangorestframework
      drf-spectacular
      markdown
      persisting-theory
      psycopg2-binary
      redis

      # Django LDAP
      django-auth-ldap
      python-ldap

      # Channels
      channels
      channels-redis

      # Celery
      kombu
      celery

      # Deployment
      uvicorn

      # Libs
      aiohttp
      arrow
      bleach
      boto3
      click
      cryptography
      defusedxml
      feedparser
      httpx
      python-ffmpeg
      liblistenbrainz
      musicbrainzngs
      mutagen
      pillow
      pyld
      python-magic
      requests
      requests-http-message-signatures
      sentry-sdk
      watchdog
      troi
      lb-matching-tools
      unidecode
      pycountry
      typesense
      ipython
      pluralizer
      service-identity
      python-slugify
    ]
    ++ channels.optional-dependencies.daphne
    ++ uvicorn.optional-dependencies.standard;

  nativeCheckInputs = with python3.pkgs; [
    postgresql
    postgresqlTestHook
    redisTestHook
    pyfakefs
    aioresponses
    factory-boy
    faker
    ipdb
    pytest
    pytest-asyncio
    prompt-toolkit
    pytest-django
    pytest-env
    pytest-mock
    pytest-randomly
    pytest-sugar
    requests-mock
    django-extensions
  ];

  postgresqlTestUserOptions = "LOGIN SUPERUSER";
  checkPhase = ''
    runHook preCheck

    DATABASE_URL="postgresql:///$PGDATABASE?host=$PGHOST&user=$PGUSER" \
    FUNKWHALE_URL="https://example.com" \
    DJANGO_SETTINGS_MODULE="config.settings.local" \
    CACHE_URL="redis://127.0.0.1:$redisTestPort/0" \
    python -m django migrate --no-input

    runHook postCheck
  '';

  # importlib.metadata.PackageNotFoundError: No package metadata was found for funkwhale
  dontCheckPythonMetadata = true;

  passthru = {
    python = python3;
    tests = { inherit (nixosTests) funkwhale; };

    static = runCommand "funkwhale-static" { } ''
      FUNKWHALE_URL="https://example.com" \
      DJANGO_SECRET_KEY="" \
      STATIC_ROOT="$out" \
        ${lib.getExe funkwhale} collectstatic --no-input
    '';

    frontend = callPackage ./frontend.nix { };

    updateScript = ./update.sh;
  };

  meta = {
    description = "Federated platform for audio streaming, exploration, and publishing";
    homepage = "https://www.funkwhale.audio/";
    downloadPage = "https://dev.funkwhale.audio/funkwhale/funkwhale";
    changelog = "https://docs.funkwhale.audio/changelog.html";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.ngi ];
    mainProgram = "funkwhale-manage";
  };
})
