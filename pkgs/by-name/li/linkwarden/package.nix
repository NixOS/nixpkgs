{
  lib,
  stdenvNoCC,
  buildNpmPackage,
  fetchFromGitHub,
  fetchYarnDeps,
  makeBinaryWrapper,
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
  # The bcrypt package requires a gyp build and its dev dependencies.
  # Linkwarden uses yarn for dependencies, bycrypt npm. Mixing the two causes issues.
  bcrypt = buildNpmPackage rec {
    pname = "bcrypt";
    version = "5.1.1";

    src = fetchFromGitHub {
      owner = "kelektiv";
      repo = "node.bcrypt.js";
      tag = "v${version}";
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
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "linkwarden";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "linkwarden";
    repo = "linkwarden";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zoJ5y2J+lkmfAFdI/7FvFAC6D308IPxaLzpGtj42IrU=";
  };

  patches = [
    /*
      Prevents NextJS from attempting to download fonts during build. The fonts
      directory will be created in the derivation script.

      See similar patches:
       pkgs/by-name/cr/crabfit-frontend/01-localfont.patch
       pkgs/by-name/al/alcom/use-local-fonts.patch
       pkgs/by-name/ne/nextjs-ollama-llm-ui/0002-use-local-google-fonts.patch
    */
    ./01-localfont.patch

    /*
      https://github.com/linkwarden/linkwarden/pull/1290

      Fixes an issue where linkwarden cannot save a plain HTTP (no TLS) website.
    */
    (fetchpatch {
      url = "https://github.com/linkwarden/linkwarden/commit/327826d760e5b1870c58a25f85501a7c9a468818.patch";
      hash = "sha256-kq1GIEW0chnPmzvg4eDSS/5WtRyWlrHlk41h4pSCMzg=";
    })
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-Z1EwecQGWHr6RZCDHAy7BA6BEoixj1dbKH3XE8sfeKQ=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    prisma
    yarnConfigHook
  ];

  buildInputs = [
    openssl
  ];

  env.NODE_ENV = "production";

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

    # Shrink closure a bit
    shopt -s extglob
    rm -rf node_modules/bcrypt node_modules/@next/swc-* node_modules/lightningcss* node_modules/react-native* node_modules/@react-native* \
      node_modules/expo* node_modules/@expo node_modules/.bin node_modules/zeego/node_modules/.bin node_modules/@react-navigation/native* \
      node_modules/@react-navigation/*/node_modules/.bin node_modules/@native-html node_modules/jest-expo node_modules/@jsamr/react-native-li \
      node_modules/lucide-react-native node_modules/@esbuild/!(linux-x64)
    shopt -u extglob

    ln -s ${bcrypt}/lib/node_modules/bcrypt node_modules/
    mkdir -p $out/share/linkwarden/apps/web/.next $out/bin
    cp -r apps/web/.next apps/web/* $out/share/linkwarden/apps/web
    cp -r apps/worker $out/share/linkwarden/apps/worker
    cp -r packages $out/share/linkwarden/
    cp -r node_modules $out/share/linkwarden/
    rm -r $out/share/linkwarden/node_modules/@linkwarden/{mobile,react-native-render-html}

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

})
