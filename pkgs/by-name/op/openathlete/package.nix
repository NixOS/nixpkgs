{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  pnpm_10,
  nodejs_22,
  nodejs-slim_22,
  makeBinaryWrapper,
  jq,
  openssl,
  prisma_6,
  prisma-engines_6,
  runCommand,
  nixosTests,
  nix-update-script,
}:

let
  pnpm = pnpm_10.override { nodejs-slim = nodejs-slim_22; };
  workspaces = [
    "@openathlete/api"
    "@openathlete/web"
    "@openathlete/shared"
    "@openathlete/database"
  ];
  # The web build loads these from a CDN, which the sandbox cannot reach: without them
  # no translated message is compiled and every label in the app is undefined
  inlangPlugin =
    {
      pkg,
      version,
      hash,
    }:
    rec {
      file = "${pkg}.js";
      url = "https://cdn.jsdelivr.net/npm/@inlang/${pkg}@${version}/dist/index.js";
      src = fetchurl {
        name = "inlang-${pkg}-${version}.js";
        inherit url hash;
      };
    };
  inlangPlugins = map inlangPlugin [
    {
      pkg = "plugin-message-format";
      version = "4.4.4";
      hash = "sha256-siz2DrKLPIw84ftjAGEaBVLxLQ2ZXTfE3SyW462AxkU=";
    }
    {
      pkg = "plugin-m-function-matcher";
      version = "2.2.16";
      hash = "sha256-hYYvYwV5O1a/2a/lNosJbmP7Kuqzi3eZwFFRe+NJnAs=";
    }
  ];
  prismaEnv = {
    PRISMA_SCHEMA_ENGINE_BINARY = lib.getExe' prisma-engines_6 "schema-engine";
    PRISMA_QUERY_ENGINE_BINARY = lib.getExe' prisma-engines_6 "query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines_6}/lib/libquery_engine.node";
    PRISMA_FMT_BINARY = lib.getExe' prisma-engines_6 "prisma-fmt";
  };
  wrapperArgs = [
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [ openssl ])
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ openssl ])
  ]
  ++ lib.concatLists (
    lib.mapAttrsToList (n: v: [
      "--set"
      n
      v
    ]) prismaEnv
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openathlete";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "openathleteorg";
    repo = "openathlete";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1yoBUoRVk9uaOZIY/2+TachsBR/9OK2DZpOJ2cm7Jso=";
  };

  outputs = [
    "out"
    "web"
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    pnpmWorkspaces = workspaces;
    inherit (finalAttrs) postPatch;
    fetcherVersion = 5;
    hash = "sha256-/QyATjwl0wFyTA+YkuU0mBM71NT9uITDEyGIXRnvdFc=";
  };

  pnpmWorkspaces = workspaces;

  strictDeps = true;
  __structuredAttrs = true;

  # nixpkgs dropped pnpm 9; the lockfile is v9.0 and installs unchanged with pnpm 10
  postPatch = ''
    substituteInPlace package.json --replace-fail '"pnpm": "^9"' '"pnpm": ">=9"'
  '';

  nativeBuildInputs = [
    nodejs_22
    pnpm
    pnpmConfigHook
    pnpmBuildHook
    prisma_6
    makeBinaryWrapper
    jq
  ];

  env = {
    # `prisma generate` reads env("DATABASE_URL") from the schema but never connects, so
    # any well-formed URL will do: this is a placeholder, not a credential
    DATABASE_URL = "postgresql://build:build@localhost:5432/build?schema=public";
    # the app reaches the API on its own origin under /api, as in upstream's Docker setup
    VITE_API_BASE_URL = "/api";
  }
  // prismaEnv;

  preBuild = ''
    (cd libs/database && prisma generate && pnpm run build:config)

    ${lib.concatMapStringsSep "\n" (plugin: ''
      install -m644 ${plugin.src} apps/web/project.inlang/${plugin.file}
      substituteInPlace apps/web/project.inlang/settings.json \
        --replace-fail ${plugin.url} ./project.inlang/${plugin.file}
    '') inlangPlugins}
  '';

  # vite only warns when a translated message is missing, so a failed plugin import would
  # ship an app whose labels are all undefined. Most of the plain English messages must
  # therefore show up in the bundle (the unused ones are tree-shaken, so not all do)
  postBuild = ''
    jq -r '.[] | strings | select(test("^[A-Za-z][A-Za-z0-9 ]{9,}$"))' apps/web/messages/en.json > "$TMPDIR/messages.txt"
    total=$(wc -l < "$TMPDIR/messages.txt")
    # grep exits 1 when nothing matches, which would abort here before the message below
    found=$({ grep -rhoFf "$TMPDIR/messages.txt" apps/web/dist/assets || true; } | sort -u | wc -l)
    if [ "$total" -eq 0 ] || [ $((found * 2)) -le "$total" ]; then
      echo "the web translations were not compiled: found $found of $total messages in the bundle" >&2
      exit 1
    fi
  '';

  doCheck = true;

  # jest and vitest start one worker per CPU of the machine, not per build core
  checkPhase = ''
    runHook preCheck

    pnpm --filter @openathlete/shared run test
    pnpm --filter @openathlete/api run test --maxWorkers=$NIX_BUILD_CORES
    pnpm --filter @openathlete/web run test --maxWorkers=$NIX_BUILD_CORES

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    root=$out/lib/openathlete
    mkdir -p $out/lib
    pnpm --filter @openathlete/api --config.inject-workspace-packages=true deploy --prod --offline --ignore-scripts $root

    cp -r apps/api/dist $root/dist
    cp -r libs/database/generated $root/node_modules/@openathlete/database/generated

    prismaCli=$(echo $root/node_modules/.pnpm/prisma@*/node_modules/prisma/build/index.js)
    test -f "$prismaCli"

    # keeps the build directory out of the closure
    substituteInPlace $root/package.json --replace-fail file:///build/source/ file:///source/

    # deploy copies the whole package directory, not only what runs
    find $root -mindepth 1 -maxdepth 1 \
      ! -name assets ! -name dist ! -name node_modules ! -name package.json -exec rm -rf {} +
    rm $root/node_modules/.pnpm/lock.yaml

    # none of this is read at runtime: the engine is the one prisma-engines provides
    # (PRISMA_QUERY_ENGINE_LIBRARY), and the app is compiled JavaScript
    find $root/node_modules $root/dist -type f \
      \( -name '*.map' -o -name '*.d.ts' -o -name '*.d.mts' -o -name '*.d.cts' -o -name '*.tsbuildinfo' \) -delete
    rm -rf $root/node_modules/.pnpm/typescript@* $root/node_modules/.pnpm/@types+*
    rm $root/node_modules/@openathlete/database/generated/client/libquery_engine.node
    find $root/node_modules/.pnpm -path '*@prisma+client*' -name '*wasm-base64*' -delete
    rm $root/node_modules/.pnpm/prisma@*/node_modules/prisma/build/query_{engine,compiler}_bg.*.wasm
    find $root/node_modules -xtype l -delete

    cp -r apps/web/dist $web

    makeWrapper ${lib.getExe nodejs-slim_22} $out/bin/openathlete-api \
      --chdir $root \
      --add-flags dist/main.js \
      --set-default NODE_ENV production \
      --set-default MASTRA_TELEMETRY_DISABLED 1 \
      ${lib.escapeShellArgs wrapperArgs}

    makeWrapper ${lib.getExe nodejs-slim_22} $out/bin/openathlete \
      --chdir $root \
      --add-flags dist/cli.js \
      --set-default NODE_ENV production \
      --set-default MASTRA_TELEMETRY_DISABLED 1 \
      ${lib.escapeShellArgs wrapperArgs}

    makeWrapper ${lib.getExe nodejs-slim_22} $out/bin/openathlete-migrate \
      --chdir $root/node_modules/@openathlete/database \
      --add-flags "$prismaCli migrate deploy" \
      --set-default CHECKPOINT_DISABLE 1 \
      --set-default PRISMA_HIDE_UPDATE_MESSAGE 1 \
      ${lib.escapeShellArgs wrapperArgs}

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) openathlete;

      migrate-help =
        runCommand "openathlete-migrate-help" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
          ''
            openathlete-migrate --help | grep -F 'prisma migrate deploy' > $out
          '';
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Self-hostable endurance training platform for athletes and coaches";
    homepage = "https://openathlete.org/";
    changelog = "https://github.com/openathleteorg/openathlete/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ paulfariello ];
    mainProgram = "openathlete-api";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
