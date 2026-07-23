{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeWrapper,
  nodejs_22,
  pnpm,
  pnpmConfigHook,
  python3,
  nix-update-script,
}:

let
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "makeplane";
    repo = "plane";
    tag = "v${version}";
    hash = "sha256-EWd9bw0uHC0KEFwebRBJV1SNM2OHfuq90+QLSr2w3j0=";
  };

  pythonEnv = python3.withPackages (
    ps: with ps; [
      # Web framework
      django
      djangorestframework
      django-cors-headers
      django-filter
      django-storages
      django-redis
      django-celery-beat
      django-celery-results
      dj-database-url
      channels
      whitenoise

      # Database
      psycopg
      psycopg.optional-dependencies.c
      pymongo

      # Cache / async
      redis
      celery
      uvicorn

      # Auth / security
      cryptography
      pyjwt
      nh3

      # Storage / files
      boto3
      lxml
      openpyxl
      beautifulsoup4

      # API tooling
      drf-spectacular
      openai
      slack-sdk
      posthog

      # Observability
      opentelemetry-api
      opentelemetry-sdk
      opentelemetry-instrumentation-django
      opentelemetry-exporter-otlp
      python-json-logger

      # Utilities
      python-dateutil
      pytz
      faker
      zxcvbn

      # Packages added alongside this derivation
      django-crum
      jsonmodels
      scout-apm

      # Production server
      gunicorn
    ]
  );

  # Frontend: web (SPA), admin (SPA), space (SSR), live (Node.js collab server).
  # The pnpmDeps hash must be computed by running this derivation with lib.fakeHash
  # and substituting the hash reported in the error.
  plane-frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "plane-frontend";
    inherit version src;

    pnpmWorkspaces = [
      "web..."
      "admin..."
      "space..."
      "live..."
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        pnpmWorkspaces
        ;
      fetcherVersion = 3;
      hash = "sha256-BQNxYWnHlYwwS+JemJPFLLWAgSiEMZIBZ2LIrZjMy88=";
    };

    nativeBuildInputs = [
      nodejs_22
      pnpm
      pnpmConfigHook
    ];

    buildPhase = ''
      runHook preBuild
      # The "..." suffix pulls in each app's workspace dependencies (e.g.
      # @plane/utils, @plane/types) so their own build scripts run first —
      # without it those internal packages' package.json exports point at
      # dist files that were never generated.
      pnpm --reporter=append-only --filter=web... --filter=admin... --filter=space... --filter=live... build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      # Trim to production-only node_modules for the SSR apps (space, live)
      pnpm --filter=space --filter=live install \
        --force --offline --production --ignore-scripts

      mkdir -p $out/share/plane/{web,admin,space/build,live}

      # web and admin: static SPA files only
      cp -r apps/web/build/client/. $out/share/plane/web/
      cp -r apps/admin/build/client/. $out/share/plane/admin/

      # space: SSR — keep full build + node_modules for react-router-serve.
      # pnpm's node_modules is a symlink farm into the workspace-root
      # .pnpm store; -L/--dereference resolves those into real files so
      # $out is self-contained (a plain cp -r left dangling symlinks
      # pointing outside $out at the un-copied central store).
      cp -r apps/space/build/. $out/share/plane/space/build/
      cp -rL apps/space/node_modules $out/share/plane/space/

      # live: Node.js collaboration server
      cp -r apps/live/dist/. $out/share/plane/live/
      cp apps/live/package.json $out/share/plane/live/
      cp -rL apps/live/node_modules $out/share/plane/live/

      runHook postInstall
    '';

    meta.license = lib.licenses.agpl3Only;
  });

in
stdenv.mkDerivation (finalAttrs: {
  pname = "plane";
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/apps/api";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  postPatch = ''
    # BASE_DIR resolves to the nix store (read-only), so redirect logs to a
    # path configurable at runtime via PLANE_LOG_DIR.  The makedirs guard in
    # production.py remains and is a no-op when the directory already exists
    # (as created by the NixOS module's tmpfiles rule).
    substituteInPlace plane/settings/production.py \
      --replace-fail \
        'LOG_DIR = os.path.join(BASE_DIR, "logs")' \
        'LOG_DIR = os.environ.get("PLANE_LOG_DIR", "/var/log/plane")'
  '';

  installPhase = ''
    runHook preInstall

    dest=$out/lib/plane
    mkdir -p "$dest" "$out/bin"
    cp -r . "$dest/"

    # plane-api: gunicorn entry point.
    # The NixOS module supplies --bind, --workers and other runtime flags.
    makeWrapper ${pythonEnv}/bin/gunicorn $out/bin/plane-api \
      --set-default DJANGO_SETTINGS_MODULE "plane.settings.production" \
      --prefix PYTHONPATH : "$dest" \
      --chdir "$dest" \
      --add-flags "-k uvicorn.workers.UvicornWorker" \
      --add-flags "plane.asgi:application" \
      --add-flags "--max-requests 1200" \
      --add-flags "--max-requests-jitter 1000" \
      --add-flags "--access-logfile -"

    makeWrapper ${pythonEnv}/bin/celery $out/bin/plane-worker \
      --set-default DJANGO_SETTINGS_MODULE "plane.settings.production" \
      --prefix PYTHONPATH : "$dest" \
      --chdir "$dest" \
      --add-flags "-A plane worker -l info"

    makeWrapper ${pythonEnv}/bin/celery $out/bin/plane-beat \
      --set-default DJANGO_SETTINGS_MODULE "plane.settings.production" \
      --prefix PYTHONPATH : "$dest" \
      --chdir "$dest" \
      --add-flags "-A plane beat -l info"

    makeWrapper ${pythonEnv}/bin/python $out/bin/plane-manage \
      --set-default DJANGO_SETTINGS_MODULE "plane.settings.production" \
      --prefix PYTHONPATH : "$dest" \
      --chdir "$dest" \
      --add-flags "$dest/manage.py"

    runHook postInstall
  '';

  passthru = {
    frontend = plane-frontend;
    python = pythonEnv;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open-source project management tool";
    longDescription = ''
      Plane is an open-source, self-hostable project management tool.
      It provides issue tracking, cycles (sprints), modules, pages, and
      analytics for software teams.
    '';
    homepage = "https://plane.so";
    changelog = "https://github.com/makeplane/plane/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
    mainProgram = "plane-api";
  };
})
