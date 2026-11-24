{
  lib,
  fetchFromGitHub,
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
let
  # Pin to 3.1.0 to match upstream poetry.lock, with >= 3.4 DB migration required
  django-oauth-toolkit' = (
    python3.pkgs.django-oauth-toolkit.overridePythonAttrs (old: {
      version = "3.1.0";
      src = fetchFromGitHub {
        owner = "django-oauth";
        repo = "django-oauth-toolkit";
        tag = "3.1.0";
        hash = "sha256-c7LaB8426qjwDveec3BghqCEtPs572PTVodvLAO2CcQ=";
      };
      preCheck = ''
        export DJANGO_SETTINGS_MODULE=tests.settings
      '';
      doCheck = true;
    })
  );
in
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "funkwhale";
  version = "2.0.18";
  pyproject = true;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "dev.funkwhale.audio";
    owner = "funkwhale";
    repo = "funkwhale";
    tag = finalAttrs.version;
    hash = "sha256-CyQ8YSGwUTcx9BU9jj+xvSDeiLsdVXdHvxZAfrEup+g=";
  };

  sourceRoot = "${finalAttrs.src.name}/api";

  patches = [
    # unicode-slugify was dropped from nixpkgs (#448893); replace with python-slugify
    ./replace-unicode-slugify.patch

    # compatibility with django-allauth >= 65.18
    ./django-allauth-compat.patch

    # fix celery task argument validation on Python 3.14
    ./celery-python314-compat.patch

    # prevent idle WebSocket disconnects under redis-py >= 8.0 default socket timeout
    ./channels-redis-timeout.patch

    # prevent duplicate tracks when filtering by artist on M2M relations
    ./fix-artist-tracks-count-distinct.patch

    # avoid duplicate albums and tracks in Subsonic getAlbumList2 and getSongsByGenre
    ./fix-subsonic-duplicates.patch

    # fix test failures in sandboxed build environment (pyfakefs for media root)
    ./fix-root-filesystem-tests.patch

    # fix test expectations for mutagen >= 1.47
    ./mutagen-compat.patch

    # normalize audio/x-flac to audio/flac for native browser playback
    ./normalize-flac-mimetype.patch

    # handle requests.exceptions.JSONDecodeError when parsing responses
    ./federation-json-decode.patch

    # ensure DomainFactory generates unique domain names for primary key
    ./domain-factory-unique.patch
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
      django-oauth-toolkit'
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

    (
      export DATABASE_URL="postgresql:///$PGDATABASE?host=$PGHOST&user=$PGUSER"
      export FUNKWHALE_URL="https://example.com"
      export DJANGO_SETTINGS_MODULE="config.settings.local"
      export CACHE_URL="redis://127.0.0.1:$redisTestPort/0"

      python -m django migrate --no-input
      python -m pytest tests
    )

    runHook postCheck
  '';

  # importlib.metadata.PackageNotFoundError: No package metadata was found for funkwhale
  dontCheckPythonMetadata = true;

  passthru = {
    python = python3;
    # prevents additional rebuild of package when toPythonModule is used in the NixOS module
    pythonModule = python3;
    tests = {
      inherit (nixosTests) funkwhale;
    };

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
