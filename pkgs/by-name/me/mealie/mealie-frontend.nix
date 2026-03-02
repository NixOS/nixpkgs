src: version:
{
  lib,
  fetchYarnDeps,
  dart-sass,
  nodejs,
  fixup-yarn-lock,
  stdenv,
  yarn,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation {
  name = "mealie-frontend";
  inherit version;
  src = "${src}/frontend";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/frontend/yarn.lock";
    hash = "sha256-sZk7OEkJdBZRU9ysRDCetzv09XrK5GhPaxxEBD8k5rw=";
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    nodejs
    (yarn.override { inherit nodejs; })
    writableTmpDirAsHomeHook
    dart-sass
  ];

  configurePhase = ''
    runHook preConfigure

    sed -i 's+"@nuxt/fonts",+// NUXT FONTS DISABLED+g' nuxt.config.ts

    yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
    fixup-yarn-lock yarn.lock
    yarn install --frozen-lockfile --offline --no-progress --non-interactive --ignore-scripts
    patchShebangs node_modules

    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["dart-sass"];'

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export NUXT_TELEMETRY_DISABLED=1
    yarn --offline generate --env production
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mv .output/public $out
    runHook postInstall
  '';

  meta = {
    description = "Frontend for Mealie";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ litchipi ];
  };
}
