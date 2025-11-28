src: version:
{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  dart-sass,
  nodePackages_latest,
  fixup-yarn-lock,
  stdenv,
  yarn,
  writableTmpDirAsHomeHook,
}:
let
  nodejs = nodePackages_latest.nodejs;
in
stdenv.mkDerivation {
  name = "mealie-frontend";
  inherit version;
  src = "${src}/frontend";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/frontend/yarn.lock";
    hash = "sha256-qwxsnl9xKzNJEomMB4p8eaiybmlpeUgSUpJtIRhF1Cw=";
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

  meta = with lib; {
    description = "Frontend for Mealie";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ litchipi ];
  };
}
