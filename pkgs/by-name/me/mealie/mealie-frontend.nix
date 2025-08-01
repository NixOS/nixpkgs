src: version:
{
  lib,
  fetchYarnDeps,
  nodejs_20,
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
    hash = "sha256-a2kIOQHaMzaMWId6+SSYN+SPQM2Ipa+F1ztFZgo3R6A=";
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    nodejs_20
    (yarn.override { nodejs = nodejs_20; })
    writableTmpDirAsHomeHook
  ];

  configurePhase = ''
    runHook preConfigure

    yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
    fixup-yarn-lock yarn.lock
    # TODO: Remove --ignore-engines once upstream supports nodejs_20+
    # https://github.com/mealie-recipes/mealie/issues/5400
    # https://github.com/mealie-recipes/mealie/pull/5184
    yarn install --frozen-lockfile --offline --no-progress --non-interactive --ignore-engines
    patchShebangs node_modules/

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
    mv dist $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Frontend for Mealie";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ litchipi ];
  };
}
