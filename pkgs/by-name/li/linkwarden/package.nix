{
  lib,
  stdenvNoCC,
  buildNpmPackage,
  fetchFromGitHub,
  fetchYarnDeps,
  makeWrapper,
  nixosTests,
  yarnBuildHook,
  yarnConfigHook,
  # dependencies
  bash,
  monolith,
  nodejs,
  openssl,
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
in
stdenvNoCC.mkDerivation rec {
  pname = "linkwarden";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "linkwarden";
    repo = "linkwarden";
    tag = "v${version}";
    hash = "sha256-mtygHx09VqrVq5eiCm8UbVM+bjA6n4MbRRT1HcWnUAo=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-D6iZp7O90ZwxyiwRZ1H67eUphh3kRplu3ucOEJIRR/w=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    prisma
    yarnBuildHook
    yarnConfigHook
  ];

  buildInputs = [
    openssl
  ];

  NODE_ENV = "production";

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "yarn worker:prod" "ts-node --transpile-only --skip-project scripts/worker.ts"

    for f in lib/api/storage/*Folder.ts lib/api/storage/*File.ts; do
      substituteInPlace $f \
        --replace-fail 'path.join(process.cwd(), storagePath + "/" + file' 'path.join(storagePath, file'
    done
  '';

  preBuild = ''
    export PRISMA_CLIENT_ENGINE_TYPE='binary'
    export PRISMA_QUERY_ENGINE_LIBRARY="${prisma-engines}/lib/libquery_engine.node"
    export PRISMA_QUERY_ENGINE_BINARY="${prisma-engines}/bin/query-engine"
    export PRISMA_SCHEMA_ENGINE_BINARY="${prisma-engines}/bin/schema-engine"
    prisma generate
  '';

  postBuild = ''
    substituteInPlace node_modules/next/dist/server/image-optimizer.js \
      --replace-fail 'this.cacheDir = (0, _path.join)(distDir, "cache", "images");' 'this.cacheDir = (0, _path.join)(process.env.LINKWARDEN_CACHE_DIR, "cache", "images");'
  '';

  installPhase = ''
    runHook preInstall

    rm -r node_modules/bcrypt node_modules/@next/swc-*
    ln -s ${bcrypt}/lib/node_modules/bcrypt node_modules/
    mkdir -p $out/share/linkwarden/.next $out/bin
    cp -r * .next $out/share/linkwarden/

    echo "#!${lib.getExe bash} -e
    export DATABASE_URL=\''${DATABASE_URL-"postgresql://\$DATABASE_USER:\$POSTGRES_PASSWORD@\$DATABASE_HOST:\$DATABASE_PORT/\$DATABASE_NAME"}
    export npm_config_cache="\$LINKWARDEN_CACHE_DIR/npm"
    ${lib.getExe prisma} migrate deploy --schema $out/share/linkwarden/prisma/schema.prisma \
      && ${lib.getExe' nodejs "npm"} start --prefix $out/share/linkwarden -- -H \$LINKWARDEN_HOST -p \$LINKWARDEN_PORT
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
      --set-default STORAGE_FOLDER /var/lib/linkwarden

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
    platforms = lib.platforms.linux;
    mainProgram = "linkwarden";
  };

}
