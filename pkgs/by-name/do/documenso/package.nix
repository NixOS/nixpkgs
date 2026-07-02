{
  lib,
  nodejs,
  node-gyp,
  node-pre-gyp,
  pixman,
  fetchFromGitHub,
  buildNpmPackage,
  prisma_6,
  prisma-engines_6,
  vips,
  pkg-config,
  cairo,
  pango,
  bash,
  openssl,
}:

buildNpmPackage (finalAttrs: {
  pname = "documenso";
  version = "1.12.6";

  src = fetchFromGitHub {
    owner = "documenso";
    repo = "documenso";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1TKjsOKJkv3COFgsE4tPAymI0MdeT+T8HiNgnoWHlAY=";
  };

  patches = [
    ./package-lock.json.patch
    ./package.json.patch
    ./turbo.json.patch
  ];

  npmDepsHash = "sha256-ZddRSBDasa3mMAS2dqXgXRMOc1nvspdXsuTZ7c+einw=";

  nativeBuildInputs = [
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
    vips
  ];

  env = {
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    PRISMA_QUERY_ENGINE_LIBRARY = "${lib.getLib prisma-engines_6}/lib/libquery_engine.node";
    PRISMA_QUERY_ENGINE_BINARY = lib.getExe' prisma-engines_6 "query-engine";
    PRISMA_SCHEMA_ENGINE_BINARY = lib.getExe' prisma-engines_6 "schema-engine";
    TURBO_NO_UPDATE_NOTIFIER = "true";
    TURBO_FORCE = "true";
    TURBO_REMOTE_CACHE_ENABLED = "false";
  };

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
    export PRISMA_SCHEMA_ENGINE_BINARY=${prisma-engines_6}
    cd $out/apps/remix
    ${lib.getExe prisma_6} migrate deploy --schema ../../packages/prisma/schema.prisma
    ${lib.getExe nodejs} build/server/main.js
    EOF
          chmod +x $out/bin/documenso

          runHook postInstall
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
    platforms = lib.platforms.unix;
    mainProgram = "documenso";
  };
})
