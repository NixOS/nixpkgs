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
  pkg-config,
  cairo,
  pango,
  bash,
  openssl,
}:
let
  pname = "documenso";
  version = "1.12.6";
in
buildNpmPackage {

  inherit version pname;

  src = fetchFromGitHub {
    owner = "documenso";
    repo = "documenso";
    rev = "v${version}";
    hash = "sha256-1TKjsOKJkv3COFgsE4tPAymI0MdeT+T8HiNgnoWHlAY=";
  };

  npmDepsHash = "sha256-ZddRSBDasa3mMAS2dqXgXRMOc1nvspdXsuTZ7c+einw=";

  env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  env.PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines}/lib/libquery_engine.node";
  env.PRISMA_QUERY_ENGINE_BINARY = "${prisma-engines}/bin/query-engine";
  env.PRISMA_SCHEMA_ENGINE_BINARY = "${prisma-engines}/bin/schema-engine";
  env.TURBO_NO_UPDATE_NOTIFIER = "true";
  env.TURBO_FORCE = "true";
  env.TURBO_REMOTE_CACHE_ENABLED = "false";

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

  patches = [
    ./package-lock.json.patch
    ./package.json.patch
    ./turbo.json.patch
  ];

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

          cat > $out/bin/${pname} <<EOF
    #!${bash}/bin/bash
    export PKG_CONFIG_PATH=${openssl.dev}/lib/pkgconfig;
    export PRISMA_QUERY_ENGINE_LIBRARY=${prisma-engines}/lib/libquery_engine.node
    export PRISMA_QUERY_ENGINE_BINARY=${prisma-engines}/bin/query-engine
    export PRISMA_SCHEMA_ENGINE_BINARY=${prisma-engines}
    cd $out/apps/remix
    ${prisma}/bin/prisma migrate deploy --schema ../../packages/prisma/schema.prisma
    ${nodejs}/bin/node build/server/main.js
    EOF
          chmod +x $out/bin/${pname}

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

  meta = with lib; {
    description = "Open Source DocuSign Alternative";
    homepage = "https://github.com/documenso/documenso";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.unix;
    mainProgram = pname;
  };
}
