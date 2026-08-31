{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs_24,
  pnpm_10,
  pnpmConfigHook,
  makeWrapper,
  python3,
  pkg-config,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "open-design";
  version = "0.21.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nexu-io";
    repo = "open-design";
    rev = "open-design-v${finalAttrs.version}";
    hash = "sha256-0aG4hyv+HnTQBcs3SxAgPJerDv6KJNQaZm3W8xd4lx8=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    pnpmWorkspaces = [
      "./packages/release"
      "./packages/contracts"
      "./packages/registry-protocol"
      "./packages/agui-adapter"
      "./packages/plugin-runtime"
      "./packages/sidecar-proto"
      "./packages/launcher-proto"
      "./packages/sidecar"
      "./packages/platform"
      "./packages/diagnostics"
      "./packages/components"
      "./packages/host"
      "./packages/download"
      "./apps/daemon"
      "./apps/web"
    ];
    hash = "sha256-yymPSQqi4Atq8CyOy2w5upo+kihyUVwfFkXnj/q7rSo=";
  };

  pnpmWorkspaces = [
    "./packages/release"
    "./packages/contracts"
    "./packages/registry-protocol"
    "./packages/agui-adapter"
    "./packages/plugin-runtime"
    "./packages/sidecar-proto"
    "./packages/launcher-proto"
    "./packages/sidecar"
    "./packages/platform"
    "./packages/diagnostics"
    "./packages/components"
    "./packages/host"
    "./packages/download"
    "./apps/daemon"
    "./apps/web"
  ];

  nativeBuildInputs = [
    nodejs_24
    pnpm_10
    pnpmConfigHook
    makeWrapper
    python3
    pkg-config
  ];

  env = {
    NODE_ENV = "production";
    OD_DAEMON_URL = "";
  };

  buildPhase = ''
    runHook preBuild

    export npm_config_nodedir=${nodejs_24}
    export npm_config_build_from_source=true
    export PATH="${nodejs_24}/lib/node_modules/npm/bin/node-gyp-bin:$PATH"

    bsq_dir=$(find node_modules/.pnpm -mindepth 2 -maxdepth 4 \
      -type d -path '*/better-sqlite3@*/node_modules/better-sqlite3' \
      -print -quit || true)
    if [ -n "$bsq_dir" ]; then
      echo "Building better-sqlite3 from source at $bsq_dir"
      ( cd "$bsq_dir" && node-gyp rebuild --release --build-from-source )
      if [ ! -f "$bsq_dir/build/Release/better_sqlite3.node" ]; then
        echo "ERROR: better_sqlite3.node not produced" >&2
        find "$bsq_dir" -name '*.node' -print >&2 || true
        exit 1
      fi
    fi

    for ws in \
      packages/release \
      packages/contracts \
      packages/registry-protocol \
      packages/agui-adapter \
      packages/plugin-runtime \
      packages/sidecar-proto \
      packages/launcher-proto \
      packages/sidecar \
      packages/platform \
      packages/diagnostics \
      packages/components \
      packages/host \
      packages/download
    do
      if [ -f "$ws/package.json" ]; then
        echo "Building $ws"
        pnpm -C "$ws" run --if-present build
      fi
    done

    echo "Building @open-design/daemon"
    pnpm -C apps/daemon run build

    echo "Building @open-design/web (static export)"
    pnpm --filter @open-design/web run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/open-design $out/bin
    cp -r . $out/lib/open-design/

    for ws in \
      packages/release \
      packages/contracts \
      packages/registry-protocol \
      packages/agui-adapter \
      packages/plugin-runtime \
      packages/sidecar-proto \
      packages/launcher-proto \
      packages/sidecar \
      packages/platform \
      packages/diagnostics \
      packages/components \
      packages/host \
      packages/download \
      apps/daemon \
      apps/web
    do
      if [ -d "$out/lib/open-design/$ws" ]; then
        if [ "$ws" = "apps/web" ]; then
          find "$out/lib/open-design/$ws" -mindepth 1 -maxdepth 1 \
            ! -name out \
            ! -name dist \
            ! -name node_modules \
            ! -name package.json \
            ! -name next.config.ts \
            -exec rm -rf {} +
        elif [ "$ws" = "apps/daemon" ]; then
          find "$out/lib/open-design/$ws" -mindepth 1 -maxdepth 1 \
            ! -name dist \
            ! -name bin \
            ! -name node_modules \
            ! -name package.json \
            -exec rm -rf {} +
        else
          find "$out/lib/open-design/$ws" -mindepth 1 -maxdepth 1 \
            ! -name dist \
            ! -name node_modules \
            ! -name package.json \
            -exec rm -rf {} +
        fi
      fi
    done

    rm -f \
      $out/lib/open-design/node_modules/@open-design/components \
      $out/lib/open-design/node_modules/@open-design/tools-dev \
      $out/lib/open-design/node_modules/@open-design/tools-pack \
      $out/lib/open-design/node_modules/@open-design/tools-release \
      $out/lib/open-design/node_modules/@open-design/tools-serve \
      $out/lib/open-design/node_modules/.bin/tools-dev \
      $out/lib/open-design/node_modules/.bin/tools-pack \
      $out/lib/open-design/node_modules/.bin/tools-release \
      $out/lib/open-design/node_modules/.bin/tools-serve \
      2>/dev/null || true
    rm -rf $out/lib/open-design/e2e 2>/dev/null || true
    rm -rf $out/lib/open-design/tools 2>/dev/null || true
    rm -rf $out/lib/open-design/shells 2>/dev/null || true

    chmod +x $out/lib/open-design/apps/daemon/dist/cli.js
    makeWrapper ${lib.getExe nodejs_24} $out/bin/od \
      --add-flags $out/lib/open-design/apps/daemon/dist/cli.js \
      --set NODE_ENV production \
      --run 'if [ -z "$OD_DATA_DIR" ]; then export OD_DATA_DIR="$HOME/.od"; fi'
    ln -s $out/bin/od $out/bin/open-design

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Local-first design product — daemon (`od` CLI) + Next.js frontend for agent-native design artifacts";
    longDescription = ''
      OpenDesign is an open-source Claude Design alternative: a local-first
      app that detects installed coding-agent CLIs (Claude Code, Codex,
      Cursor, etc.), runs functional skills and design-system contracts,
      and streams artifacts (prototypes, decks, dashboards, images,
      HyperFrames video) into a sandboxed preview. The `od` CLI starts
      the local Express + SQLite daemon that powers the web UI and MCP
      server. This package builds both the daemon and the static web
      export (apps/web/out) so `od` can serve the UI without an external
      reverse proxy.
    '';
    homepage = "https://github.com/nexu-io/open-design";
    downloadPage = "https://github.com/nexu-io/open-design/releases";
    changelog = "https://github.com/nexu-io/open-design/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ReStranger ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "od";
  };
})
