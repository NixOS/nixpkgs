src: version:
{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  dart,
  dart-sass,
  nodePackages_latest,
  fixup-yarn-lock,
  stdenv,
  yarn,
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
    hash = "sha256-712mc/xksjXgnc0inthxE+ztSDl/4107oXw3vKcZD2g=";
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    nodejs
    (yarn.override { inherit nodejs; })
  ];

  configurePhase = ''
    runHook preConfigure

    sed -i 's+"@nuxt/fonts",+// NUXT FONTS DISABLED+g' nuxt.config.ts

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
    fixup-yarn-lock yarn.lock
    yarn install --frozen-lockfile --offline --no-progress --non-interactive
    patchShebangs node_modules/

    mkdir -p node_modules/sass-embedded/dist/lib/src/vendor/dart-sass
    ln -s ${dart-sass}/bin/dart-sass node_modules/sass-embedded/dist/lib/src/vendor/dart-sass/sass

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export NUXT_TELEMETRY_DISABLED=1
    yarn --offline build
    yarn --offline generate

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
