{
  lib,
  stdenv,
  nodejs,
  node-gyp,
  node-pre-gyp,
  pixman,
  fetchFromGitHub,
  fetchurl,
  buildNpmPackage,
  prisma_6,
  prisma-engines_6,
  vips,
  pkg-config,
  gzip,
  autoPatchelfHook,
  cairo,
  pango,
  bash,
  openssl,
}:

let
  skiaCanvasVersion = "3.0.8";
  skiaCanvasTriplet =
    {
      x86_64-linux = "linux-x64-glibc";
      aarch64-linux = "linux-arm64-glibc";
    }
    .${stdenv.hostPlatform.system}
      or (throw "unsupported skia-canvas platform ${stdenv.hostPlatform.system}");
  skiaCanvasPrebuild = fetchurl {
    url = "https://github.com/samizdatco/skia-canvas/releases/download/v${skiaCanvasVersion}/${skiaCanvasTriplet}.gz";
    hash =
      {
        x86_64-linux = "sha256-9FklKQWZ1LfLUhHBI/re4nvImddVZpbi4zPQ76xpN7I=";
        aarch64-linux = "sha256-BmXQemDAXZEqL9FFmus3cU6wRFwveEhAdjhUbD0uGnA=";
      }
      .${stdenv.hostPlatform.system};
  };
in
buildNpmPackage (finalAttrs: {
  pname = "documenso";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "documenso";
    repo = "documenso";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZVcbOKBqjDnCo2pZKjaAuO3MK7r/S6k4kEHwBteHVGg=";
  };

  patches = [
    ./package-lock.json.patch
    ./package.json.patch
    ./turbo.json.patch
  ];

  npmDepsHash = "sha256-/Jt1ct/GSumu/pgTrmnVHdMhhg8J2Epvu7wnnCakqGs=";
  npmDepsFetcherVersion = 2;

  nativeBuildInputs = [
    autoPatchelfHook
    gzip
    pkg-config
    vips
    node-gyp
  ];

  buildInputs = [
    node-pre-gyp
    node-gyp
    pixman
    cairo
    pango
    stdenv.cc.cc.lib
    vips
  ];

  npmRebuildFlags = [ "--ignore-scripts" ];

  env = {
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    PRISMA_QUERY_ENGINE_LIBRARY = "${lib.getLib prisma-engines_6}/lib/libquery_engine.node";
    PRISMA_QUERY_ENGINE_BINARY = lib.getExe' prisma-engines_6 "query-engine";
    PRISMA_SCHEMA_ENGINE_BINARY = lib.getExe' prisma-engines_6 "schema-engine";
    TURBO_NO_UPDATE_NOTIFIER = "true";
    TURBO_FORCE = "true";
    TURBO_REMOTE_CACHE_ENABLED = "false";
  };

  preBuild = ''
    mkdir -p node_modules/skia-canvas/lib
    gzip -dc ${skiaCanvasPrebuild} > node_modules/skia-canvas/lib/skia.node

    npm exec patch-package
  '';

  buildPhase = ''
    runHook preBuild

    patchShebangs apps/remix/.bin/build.sh
    npm exec turbo -- telemetry disable
    npm exec turbo -- build --filter=@documenso/remix

    runHook postBuild
  '';

  installPhase = ''
          runHook preInstall

          mkdir -p $out/bin
          cp -r . $out/

          cat > $out/bin/documenso <<EOF
    #!${bash}/bin/bash
    export PKG_CONFIG_PATH=${lib.getLib openssl.dev}/lib/pkgconfig;
    export PRISMA_QUERY_ENGINE_LIBRARY=${lib.getLib prisma-engines_6}/lib/libquery_engine.node
    export PRISMA_QUERY_ENGINE_BINARY=${lib.getExe' prisma-engines_6 "query-engine"}
    export PRISMA_SCHEMA_ENGINE_BINARY=${lib.getExe' prisma-engines_6 "schema-engine"}
    cd $out/apps/remix
    ${lib.getExe prisma_6} migrate deploy --schema ../../packages/prisma/schema.prisma
    ${lib.getExe nodejs} build/server/main.js
    EOF
          chmod +x $out/bin/documenso

          runHook postInstall
  '';

  postInstall = ''
    # These optional prebuilds are for musl libc and can make autoPatchelf link
    # glibc addons against incompatible vendored libraries.
    rm -rf $out/node_modules/*musl* $out/node_modules/@*/*musl*
    rm -rf $out/node_modules/@datadog/pprof/prebuilds/linuxmusl-*
    rm -rf $out/node_modules/aws-crt/dist/bin/linux-*-musl
  '';

  # cleanup dangling symlinks for workspaces
  preFixup = ''
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/assets
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/lib
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/documentation
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/prettier-config
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/signing
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/ui
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/eslint-config
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/tailwind-config
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/email
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/prisma
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/remix
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/openpage-api
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/api
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/tsconfig
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/app-tests
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/trpc
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/ee
    rm -Rf $out/lib/node_modules/@documenso/root/node_modules/@documenso/auth
  '';

  meta = {
    description = "Open Source DocuSign Alternative";
    homepage = "https://github.com/documenso/documenso";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "documenso";
  };
})
