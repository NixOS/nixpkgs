{
  lib,
  nodejs,
  node-gyp,
  node-pre-gyp,
  pixman,
  fetchFromGitHub,
  buildNpmPackage,
  prisma,
  prisma-engines,
  vips,
  giflib,
  pkg-config,
  cairo,
  pango,
  openssl,
  turbo,
  cacert,
  callPackage,
  makeWrapper,
}:
let
  skia-canvas = callPackage ./skia-canvas.nix { };
in
buildNpmPackage (finalAttrs: {
  pname = "documenso";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "documenso";
    repo = "documenso";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dqsxqdhbh6OZ/rWdXMSZ/XQiZvyM4ugJslMoBE4HY7M=";
  };

  npmDepsHash = "sha256-aV8MnJDr70lKumKteOgqGepcchPoFjw+r0s245LbV3M=";

  env = {
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

    PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines}/lib/libquery_engine.node";
    PRISMA_QUERY_ENGINE_BINARY = "${prisma-engines}/bin/query-engine";
    PRISMA_SCHEMA_ENGINE_BINARY = "${prisma-engines}/bin/schema-engine";
    TURBO_FORCE = "true";
    TURBO_REMOTE_CACHE_ENABLED = "false";
  };

  nativeBuildInputs = [
    cacert # required by turbo
    turbo
    pkg-config
    vips
    node-gyp
    makeWrapper
  ];

  buildInputs = [
    node-pre-gyp
    node-gyp
    giflib
    pixman
    cairo
    pango
    vips
  ];

  patches = [
    ./package-lock.json.patch
    ./package.json.patch
  ];

  npmFlags = [ "--ignore-scripts" ];

  buildPhase = ''
    runHook preBuild

    cp ${skia-canvas}/lib/libskia_canvas.* node_modules/skia-canvas/lib/skia.node

    # rebuild and run install scripts after skia binary is inplace,
    # otherwise package will try to fetch it
    npm rebuild
    patchShebangs node_modules

    patchShebangs apps/remix/.bin/build.sh
    turbo build --filter=@documenso/remix

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r . $out/

    makeWrapper ${prisma}/bin/prisma $out/bin/${finalAttrs.pname}-prima-migrate \
      --chdir $out/apps/remix \
      --set PKG_CONFIG_PATH ${openssl.dev}/lib/pkgconfig \
      --set PRISMA_QUERY_ENGINE_LIBRARY ${finalAttrs.env.PRISMA_QUERY_ENGINE_LIBRARY} \
      --set PRISMA_QUERY_ENGINE_BINARY ${finalAttrs.env.PRISMA_QUERY_ENGINE_BINARY} \
      --set PRISMA_SCHEMA_ENGINE_BINARY ${finalAttrs.env.PRISMA_SCHEMA_ENGINE_BINARY} \
      --add-flags "migrate deploy --schema ../../packages/prisma/schema.prisma"

    makeWrapper ${nodejs}/bin/node $out/bin/${finalAttrs.pname} \
      --run $out/bin/${finalAttrs.pname}-prima-migrate \
      --chdir $out/apps/remix \
      --set PKG_CONFIG_PATH ${openssl.dev}/lib/pkgconfig \
      --set PRISMA_QUERY_ENGINE_LIBRARY ${finalAttrs.env.PRISMA_QUERY_ENGINE_LIBRARY} \
      --set PRISMA_QUERY_ENGINE_BINARY ${finalAttrs.env.PRISMA_QUERY_ENGINE_BINARY} \
      --set PRISMA_SCHEMA_ENGINE_BINARY ${finalAttrs.env.PRISMA_SCHEMA_ENGINE_BINARY} \
      --add-flag build/server/main.js

    runHook postInstall
  '';

  passthru = {
    inherit skia-canvas;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Open Source DocuSign Alternative";
    homepage = "https://github.com/documenso/documenso";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.unix;
    mainProgram = finalAttrs.pname;
  };
})
