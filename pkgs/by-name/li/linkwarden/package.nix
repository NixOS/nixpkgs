{
  lib,
  stdenvNoCC,
  buildNpmPackage,
  fetchFromGitHub,
  fetchYarnDeps,
  makeWrapper,
  nixosTests,
  yarnConfigHook,
  fetchpatch,
  # dependencies
  bash,
  monolith,
  nodejs,
  openssl,
  google-fonts,
  playwright-driver,
  prisma,
  prisma-engines,
}:

let
  bcrypt = buildNpmPackage rec {
    pname = "bcrypt";
    version = "5.1.1";

    src = fetchFromGitHub {
      owner = "kelektiv";
      repo = "node.bcrypt.js";
      rev = "v${version}";
      hash = "sha256-mgfYEgvgC5JwgUhU8Kn/f1D7n9ljnIODkKotEcxQnDQ=";
    };

    npmDepsHash = "sha256-CPXZ/yLEjTBIyTPVrgCvb+UGZJ6yRZUJOvBSZpLSABY=";

    npmBuildScript = "install";

    postInstall = ''
      cp -r lib $out/lib/node_modules/bcrypt/
    '';
  };

  google-fonts' = google-fonts.override {
    fonts = [
      "Caveat"
      "Bentham"
    ];
  };
in
stdenvNoCC.mkDerivation rec {
  pname = "linkwarden";
  version = "2.11.5";

  src = fetchFromGitHub {
    owner = "linkwarden";
    repo = "linkwarden";
    tag = "v${version}";
    hash = "sha256-H2qMntLfLWMsvOYA24V34zhJOA4LhzCiDMGQtD8ceEo=";
  };

  patches = [
    ./01-localfont.patch
    (fetchpatch {
      url = "https://github.com/linkwarden/linkwarden/pull/1290.patch";
      hash = "sha256-kq1GIEW0chnPmzvg4eDSS/5WtRyWlrHlk41h4pSCMzg=";
    })
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-dqkaTMQYufUjENteOeS82B+/vZxbvCMOcmaP6IODm1w=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    prisma
    yarnConfigHook
  ];

  buildInputs = [
    openssl
  ];

  NODE_ENV = "production";

  postPatch = ''
    for f in packages/filesystem/*Folder.ts packages/filesystem/*File.ts; do
      substituteInPlace $f \
        --replace-fail 'process.cwd(),' "" \
        --replace-fail '"../..",' ""
    done
  '';

  preBuild = ''
    export PRISMA_CLIENT_ENGINE_TYPE='binary'
    export PRISMA_QUERY_ENGINE_LIBRARY="${prisma-engines}/lib/libquery_engine.node"
    export PRISMA_QUERY_ENGINE_BINARY="${prisma-engines}/bin/query-engine"
    export PRISMA_SCHEMA_ENGINE_BINARY="${prisma-engines}/bin/schema-engine"
  '';

  buildPhase = ''
    runHook preBuild

    cp ${google-fonts'}/share/fonts/truetype/Bentham-* ./apps/web/public/bentham.ttf
    cp ${google-fonts'}/share/fonts/truetype/Caveat* ./apps/web/public/caveat.ttf

    yarn prisma:generate
    yarn web:build

    runHook postBuild
  '';

  postBuild = ''
    substituteInPlace node_modules/next/dist/server/image-optimizer.js \
      --replace-fail 'this.cacheDir = (0, _path.join)(distDir, "cache", "images");' 'this.cacheDir = (0, _path.join)(process.env.LINKWARDEN_CACHE_DIR, "cache", "images");'
  '';

  installPhase = ''
    runHook preInstall

    rm -r node_modules/bcrypt node_modules/@next/swc-*
    ln -s ${bcrypt}/lib/node_modules/bcrypt node_modules/
    mkdir -p $out/share/linkwarden/apps/web/.next $out/bin
    cp -r apps/web/.next apps/web/* $out/share/linkwarden/apps/web
    cp -r apps/worker $out/share/linkwarden/apps/worker
    cp -r packages $out/share/linkwarden/
    cp -r node_modules $out/share/linkwarden/
    rm -r $out/share/linkwarden/node_modules/mobile-app

    echo "#!${lib.getExe bash} -e
    export DATABASE_URL=\''${DATABASE_URL-"postgresql://\$DATABASE_USER:\$POSTGRES_PASSWORD@\$DATABASE_HOST:\$DATABASE_PORT/\$DATABASE_NAME"}
    export npm_config_cache="\$LINKWARDEN_CACHE_DIR/npm"

    if [ \"\$1\" == \"worker\" ]; then
      echo "Starting worker"
      ${lib.getExe' nodejs "npm"} start --prefix $out/share/linkwarden/apps/worker
    else
      echo "Starting server"
      ${lib.getExe prisma} migrate deploy --schema $out/share/linkwarden/packages/prisma/schema.prisma \
        && ${lib.getExe' nodejs "npm"} start --prefix $out/share/linkwarden/apps/web -- -H \$LINKWARDEN_HOST -p \$LINKWARDEN_PORT
    fi
    " > $out/bin/start.sh
    chmod +x $out/bin/start.sh

    makeWrapper $out/bin/start.sh $out/bin/linkwarden \
      --prefix PATH : "${
        lib.makeBinPath [
          bash
          monolith
          openssl
        ]
      }" \
      --set-default PRISMA_CLIENT_ENGINE_TYPE 'binary' \
      --set-default PRISMA_QUERY_ENGINE_LIBRARY "${prisma-engines}/lib/libquery_engine.node" \
      --set-default PRISMA_QUERY_ENGINE_BINARY "${prisma-engines}/bin/query-engine" \
      --set-default PRISMA_SCHEMA_ENGINE_BINARY "${prisma-engines}/bin/schema-engine" \
      --set-default PLAYWRIGHT_LAUNCH_OPTIONS_EXECUTABLE_PATH ${playwright-driver.browsers-chromium}/chromium-*/chrome-linux/chrome \
      --set-default LINKWARDEN_CACHE_DIR /var/cache/linkwarden \
      --set-default LINKWARDEN_HOST localhost \
      --set-default LINKWARDEN_PORT 3000 \
      --set-default STORAGE_FOLDER /var/lib/linkwarden \
      --set-default NEXT_TELEMETRY_DISABLED 1

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) linkwarden;
  };

  meta = {
    description = "Self-hosted collaborative bookmark manager to collect, organize, and preserve webpages, articles, and more...";
    homepage = "https://linkwarden.app/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jvanbruegge ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "linkwarden";
  };

}
