{
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  nodejs,
  pnpm,
  prisma-engines,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hoppscotch-community-edition";
  version = "2024.8.1";

  src = fetchFromGitHub {
    owner = "hoppscotch";
    repo = "hoppscotch";
    rev = finalAttrs.version;
    hash = "sha256-qXBiL573n4iX4KQ86UL1eGV2Ox9hlGZe/edF10f11PM=";
  };

  prePnpmInstall = ''
    pnpm config set dedupe-peer-dependants false
  '';
  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      prePnpmInstall
      ;
    hash = "sha256-9J15k1ZSU4UBuXNN/b+vwRKNsk2MgrTXMRLyYX9TtIg=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpm.configHook
  ];

  # Prisma doesn't detect NixOS bindings by default
  # See https://github.com/prisma/prisma/issues/22145
  PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines}/lib/libquery_engine.node";
  PRISMA_QUERY_ENGINE_BINARY = lib.getExe' prisma-engines "query-engine";
  PRISMA_SCHEMA_ENGINE_BINARY = lib.getExe' prisma-engines "schema-engine";

  buildPhase = ''
    runHook preBuild

    pnpm --filter=@hoppscotch/common build
    pnpm --filter=@hoppscotch/data build
    pnpm --filter=@hoppscotch/js-sandbox build
    pnpm --filter=@hoppscotch/cli build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp -r {packages,node_modules} $out/lib

    # Backend build
    # cd $out/lib/packages/hoppscotch-backend
    # pnpm exec prisma generate
    # pnpm run build
    # pnpm --filter=hoppscotch-backend --prod deploy $out/dist/backend
    # cd $out/dist/backend
    # pnpm exec prisma generate

    # Frontend build
    # cd $out/lib/packages/hoppscotch-selfhost-web
    # pnpm run generate

    # SH Admin build
    # cd $out/lib/packages/hoppscotch-sh-admin
    # pnpm run build --outDir $out/dist/sh-admin-multiport-setup
    # pnpm run build --outDir $out/dist/sh-admin-subpath-access --base /admin/

    # Copy necessary files
    # cp $out/lib/packages/hoppscotch-backend/backend.Caddyfile $out/etc/caddy/backend.Caddyfile
    # cp $out/lib/packages/hoppscotch-backend/prod_run.mjs $out/dist/backend/
    # cp $out/lib/packages/hoppscotch-selfhost-web/selfhost-web.Caddyfile $out/etc/caddy/selfhost-web.Caddyfile
    # cp $out/lib/packages/hoppscotch-sh-admin/sh-admin-multiport-setup.Caddyfile $out/etc/caddy/sh-admin-multiport-setup.Caddyfile
    # cp $out/lib/packages/hoppscotch-sh-admin/sh-admin-subpath-access.Caddyfile $out/etc/caddy/sh-admin-subpath-access.Caddyfile
    # cp $out/lib/aio_run.mjs $out/
    # cp $out/lib/aio-multiport-setup.Caddyfile $out/etc/caddy/aio-multiport-setup.Caddyfile
    # cp $out/lib/aio-subpath-access.Caddyfile $out/etc/caddy/aio-subpath-access.Caddyfile

    # cleanup
    rm -r $out/lib/packages/hoppscotch-{cli,data,js-sandbox}/src
    find $out/lib/packages/hoppscotch-{cli,data,js-sandbox} -name '*.ts' -delete

    makeWrapper ${lib.getExe nodejs} $out/bin/hoppscotch \
      --inherit-argv0 \
      --add-flags $out/lib/packages/hoppscotch-cli/bin/hopp.js

    runHook postInstall
  '';

  postInstall = ''
    install -D -m444 ${finalAttrs.src}/packages/hoppscotch-common/public/logo.svg $out/share/icons/hicolor/scalable/apps/hoppscotch.svg
  '';

  meta = {
    changelog = "https://hoppscotch.com/changelog";
    description = "Open source API development ecosystem";
    longDescription = ''
      Hoppscotch is a lightweight, web-based API development suite. It was built
      from the ground up with ease of use and accessibility in mind providing
      all the functionality needed for API developers with minimalist,
      unobtrusive UI.
    '';
    homepage = "https://hoppscotch.com";
    downloadPage = "https://hoppscotch.com/downloads";
    license = lib.licenses.mit;
    mainProgram = "hoppscotch";
    maintainers = with lib.maintainers; [ getpsyched ];
    platforms = lib.platforms.all;
  };
})
