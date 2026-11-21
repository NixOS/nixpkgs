{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_11,
  nodejs_24,
  python3,
  pkg-config,
  node-gyp,
  makeWrapper,
  cacert,
}:

let
  pnpm = pnpm_11;
  nodejs = nodejs_24;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "aiostreams";
  version = "2.33.2";

  strictDeps = true;
  __structuredAttrs = true;

  # AIOStreams v2.33.2 locks better-sqlite3@^12.10.0 (resolves to 12.11.1),
  # which crashes (SIGABRT, "Assertion failed: (env) != nullptr" in
  # RemoveEnvironmentCleanupHook) under nodejs_24 24.19.0+ — a known
  # incompatibility between its old bindings-based native addon and
  # changed Node internals. better-sqlite3 13.x fixed this by migrating to
  # node-addon-api (see https://github.com/WiseLibs/better-sqlite3/releases).
  # Not fixable by swapping files post-install since 13.x has a different
  # dependency graph (node-addon-api instead of bindings/prebuild-install),
  # so the override is applied here, at fetch time, with a real pnpm
  # resolve — this keeps fetchPnpmDeps and the main build working from the
  # same already-correct lockfile rather than each re-deriving it.
  # TODO: drop this override once upstream bumps better-sqlite3 itself.
  src = fetchFromGitHub {
    owner = "Viren070";
    repo = "AIOStreams";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rzlh5q189dlvmXXL1wWX0cVdg9hRlQf7xJLEdwZayL8=";
    nativeBuildInputs = [
      nodejs
      pnpm
      cacert
    ];
    postFetch = ''
      cd "$out"
      printf '\noverrides:\n  better-sqlite3: ^13.0.0\n' >> pnpm-workspace.yaml
      export HOME="$(mktemp -d)"
      export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
      export pnpm_config_pm_on_fail=ignore
      pnpm install --no-frozen-lockfile --ignore-scripts --lockfile-only
    '';
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-5prpFlr92f7Hs29bWSxhRTKSaq5SJ3c4UcMmuh0kVQ8=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    python3
    pkg-config
    node-gyp # yencode (native usenet engine dep) has no prebuilt binary on all platforms
    makeWrapper
  ];

  # fix for node-gyp, see https://github.com/nodejs/node-gyp/issues/1191#issuecomment-301243919
  env.npm_config_nodedir = nodejs;

  buildPhase = ''
    runHook preBuild

    pnpm run build

    # scripts/generateMetadata.cjs shells out to `git`, which isn't available
    # for a fetchFromGitHub source (no .git dir). Write the same shape by hand.
    mkdir -p resources
    cat > resources/metadata.json <<EOF
    {
      "version": "${finalAttrs.version}",
      "description": "AIOStreams consolidates multiple Stremio addons and debrid/usenet services into a single, highly customisable super-addon.",
      "tag": "v${finalAttrs.version}",
      "channel": "stable",
      "commitHash": "f36d0f93",
      "buildTime": "1970-01-01T00:00:00.000Z",
      "commitTime": "1970-01-01T00:00:00.000Z"
    }
    EOF

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    local -r packageOut="$out/lib/node_modules/aiostreams"

    # Mirror upstream's Dockerfile runtime stage: drop dev deps, reinstall
    # prod-only from the same offline store pnpmConfigHook already populated.
    rm -rf node_modules packages/*/node_modules
    pnpm install --prod --offline --ignore-scripts --frozen-lockfile

    # yencode and better-sqlite3 are native addons in pnpm-workspace.yaml's
    # allowBuilds list, but --ignore-scripts above skipped their node-gyp
    # compiles. `pnpm rebuild` uses pnpm's own bundled node-gyp, which does
    # not pick up npm_config_nodedir the way the nixpkgs node-gyp on PATH
    # does, so it tries (and fails, offline) to download node headers.
    # Compile them directly instead.
    (cd packages/core/node_modules/yencode && node-gyp rebuild)
    (cd packages/core/node_modules/better-sqlite3 && node-gyp rebuild --release)

    mkdir -p "$packageOut"
    cp package*.json LICENSE pnpm-workspace.yaml pnpm-lock.yaml "$packageOut/"
    cp -r patches resources scripts "$packageOut/"

    mkdir -p "$packageOut/packages/core" "$packageOut/packages/server" \
      "$packageOut/packages/frontend" "$packageOut/packages/seanime-extensions"

    cp packages/core/package*.json "$packageOut/packages/core/"
    cp -r packages/core/dist "$packageOut/packages/core/dist"
    cp -r packages/core/node_modules "$packageOut/packages/core/node_modules"

    cp packages/server/package*.json "$packageOut/packages/server/"
    cp -r packages/server/dist "$packageOut/packages/server/dist"
    cp -r packages/server/node_modules "$packageOut/packages/server/node_modules"
    cp -r packages/server/src/static "$packageOut/packages/server/dist/static"

    cp -r packages/frontend/dist "$packageOut/packages/frontend/dist"
    cp -r packages/seanime-extensions/dist "$packageOut/packages/seanime-extensions/dist"

    cp -r node_modules "$packageOut/node_modules"

    # Prune dangling symlinks to unbuilt workspace members we don't ship
    # (e.g. the "docs" fumadocs site) — not needed to run the server.
    find "$packageOut" -xtype l -delete

    makeWrapper '${lib.getExe' nodejs "node"}' "$out/bin/aiostreams" \
      --add-flags "$packageOut/packages/server/dist/server.js" \
      --chdir "$packageOut"

    runHook postInstall
  '';

  meta = {
    description = "Consolidates multiple Stremio addons and debrid/usenet services into a single, highly customisable super-addon";
    homepage = "https://github.com/Viren070/AIOStreams";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ manfredmacx ];
    mainProgram = "aiostreams";
    platforms = lib.platforms.linux;
  };
})
