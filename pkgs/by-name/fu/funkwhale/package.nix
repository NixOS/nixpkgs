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
  typesense,
  curl,

  nix-update-script,
}:
let
  python = python3;

  meta = {
    description = "Federated platform for audio streaming, exploration, and publishing";
    homepage = "https://www.funkwhale.audio/";
    downloadPage = "https://dev.funkwhale.audio/funkwhale/funkwhale";
    changelog = "https://docs.funkwhale.audio/changelog.html";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.ngi ];
    mainProgram = "funkwhale-manage";
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "funkwhale";
  version = "2.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "dev.funkwhale.audio";
    owner = "funkwhale";
    repo = "funkwhale";
    tag = version;
    hash = "sha256-hMxVWnKa2n8ZmY8A2J8603tpyRvTH/Po37gZDBmRKWY=";
  };

  sourceRoot = "${src.name}/api";

  patches = [
    # `unicode-slugify` was removed from nixpkgs.
    # See https://github.com/NixOS/nixpkgs/pull/448893.
    ./replace-unicode-slugify.patch

    ./fix-root-filesystem-tests.patch
  ];

  build-system = with python.pkgs; [
    poetry-core
  ];

  # Everything is pinned to specific versions.
  pythonRelaxDeps = true;
  pythonRemoveDeps = [
    # Not used directly.
    "gunicorn"
  ];

  dependencies =
    with python.pkgs;
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

      # Typesense
      #typesense
      # Remove once https://github.com/NixOS/nixpkgs/pull/503394 is merged
      (python3.pkgs.callPackage ./deps/typesense { inherit typesense curl; })

      ipython
      pluralizer
      service-identity
      python-slugify
    ]
    ++ channels.optional-dependencies.daphne
    ++ uvicorn.optional-dependencies.standard;

  nativeCheckInputs = with python.pkgs; [
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
    CACHE_URL="redis://$REDIS_SOCKET:6379/0" \
    python -m django migrate --no-input

    runHook postCheck
  '';

  passthru = {
    inherit python;

    static = runCommand "funkwhale-static" { } ''
      FUNKWHALE_URL="https://example.com" \
      DJANGO_SECRET_KEY="" \
      STATIC_ROOT="$out" \
        ${lib.getExe funkwhale} collectstatic --no-input
    '';

    frontend = callPackage ./frontend.nix { };

    # TODO experimental combinator
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };

    inherit meta;
  };
}
