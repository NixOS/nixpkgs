{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildNpmPackage,
  makeWrapper,
  nix-update-script,
  nixosTests,
  p7zip,
  python3,
  runtimeShell,
}:

stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    inherit (finalAttrs.passthru) frontend pythonEnv;
  in
  {
    pname = "romm";
    version = "5.1.0";

    src = fetchFromGitHub {
      owner = "rommapp";
      repo = "romm";
      tag = finalAttrs.version;
      hash = "sha256-oFJ0R4m3bH2qQ18uTDm749la4oBMBj17Y5lF/eE/6tU=";
    };

    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [ makeWrapper ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/romm
      cp -r backend $out/share/romm/backend
      ln -s ${frontend} $out/share/romm/frontend
      # njs handler for the internal /decode endpoint of upstream's nginx setup
      cp docker/nginx/js/decode.js $out/share/romm/decode.js

      wrap() {
        makeWrapper "$1" "$out/bin/$2" \
          --chdir $out/share/romm/backend \
          --set PYTHONPATH $out/share/romm/backend \
          --prefix PATH : ${lib.makeBinPath [ p7zip ]} \
          "''${@:3}"
      }

      wrap ${pythonEnv}/bin/alembic romm-migrate --add-flags "upgrade head"

      wrap ${pythonEnv}/bin/python romm-startup --add-flags "startup.py"

      # forwarded-allow-ips is left to gunicorn's FORWARDED_ALLOW_IPS handling
      # (default 127.0.0.1) rather than upstream's container-only "*".
      wrap ${pythonEnv}/bin/gunicorn romm --add-flags "main:app" \
        --set-default ROMM_HOST 127.0.0.1 \
        --set-default ROMM_PORT 8080 \
        --run 'export GUNICORN_CMD_ARGS="--bind=''${ROMM_HOST}:''${ROMM_PORT} --worker-class uvicorn_worker.UvicornWorker --workers ''${WEB_SERVER_CONCURRENCY:-''${WEB_CONCURRENCY:-2}} --timeout ''${WEB_SERVER_TIMEOUT:-300} ''${GUNICORN_CMD_ARGS:-}"'

      wrap ${pythonEnv}/bin/rq romm-worker \
        --add-flags "worker --path $out/share/romm/backend --worker-class handler.rq_worker.RomMWorker high default low"

      wrap ${pythonEnv}/bin/rqscheduler romm-scheduler \
        --add-flags "--path $out/share/romm/backend"

      cat > $out/bin/romm-watcher <<EOF
      #!${runtimeShell}
      export PYTHONPATH="$out/share/romm/backend"
      export PATH="${lib.makeBinPath [ p7zip ]}:\$PATH"
      cd "$out/share/romm/backend"
      exec ${pythonEnv}/bin/watchfiles --target-type command \
        "${pythonEnv}/bin/python watcher.py" "\''${1:-\''${ROMM_BASE_PATH:-/var/lib/romm}/library}"
      EOF
      chmod +x $out/bin/romm-watcher

      runHook postInstall
    '';

    passthru = {
      # Upstream is a uv workspace application (`package = false`), so the
      # backend is not pip-installable; it runs from source with its
      # dependencies on PYTHONPATH.
      pythonEnv = python3.withPackages (
        ps: with ps; [
          aiohttp
          alembic
          anyio
          asyncssh
          authlib
          bcrypt
          colorama
          cryptography
          defusedxml
          email-validator
          fastapi
          fastapi-pagination
          gunicorn
          httpx
          itsdangerous
          jinja2
          joserfc
          mariadb
          mutagen
          mysql-connector-python
          opentelemetry-distro
          opentelemetry-exporter-otlp
          opentelemetry-instrumentation-aiohttp-client
          opentelemetry-instrumentation-fastapi
          opentelemetry-instrumentation-httpx
          opentelemetry-instrumentation-redis
          opentelemetry-instrumentation-sqlalchemy
          passlib
          pillow
          psycopg
          pydantic
          pydash
          python-dotenv
          python-magic
          python-multipart
          python-socketio
          pyyaml
          redis
          rq
          rq-scheduler
          sentry-sdk
          sqlalchemy
          starlette
          streaming-form-data
          strsimpy
          ua-parser
          unidecode
          uvicorn
          uvicorn-worker
          watchfiles
          yarl
          zipfile-inflate64
          zstandard
        ]
      );

      frontend = buildNpmPackage {
        pname = "romm-frontend";
        inherit (finalAttrs) version;
        src = "${finalAttrs.src}/frontend";

        npmDepsHash = "sha256-rNi0x8vbPkLEiDlf94SPTg4aKguSzVHR5zBouLJulKo=";
        npmFlags = [ "--ignore-scripts" ];
        makeCacheWritable = true;

        installPhase = ''
          runHook preInstall
          cp -r dist $out
          # merge static assets into the web root, as upstream's image does
          chmod u+w $out/assets
          cp -r assets/. $out/assets/
          runHook postInstall
        '';
      };

      tests = {
        inherit (nixosTests) romm;
      };

      updateScript = nix-update-script {
        extraArgs = [
          "--subpackage"
          "frontend"
        ];
      };
    };

    meta = {
      description = "Self-hosted ROM manager and player";
      homepage = "https://romm.app/";
      changelog = "https://github.com/rommapp/romm/releases/tag/${finalAttrs.version}";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [
        denzonl
        jk
      ];
      mainProgram = "romm";
      platforms = lib.platforms.linux;
    };
  }
)
