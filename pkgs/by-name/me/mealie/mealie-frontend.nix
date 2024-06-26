src: version:
{ lib, fetchYarnDeps, nodejs_18, fixup-yarn-lock, stdenv }: stdenv.mkDerivation {
  name = "mealie-frontend";
  inherit version;
  src = "${src}/frontend";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/frontend/yarn.lock";
    hash = "sha256-a2kIOQHaMzaMWId6+SSYN+SPQM2Ipa+F1ztFZgo3R6A=";
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    nodejs_18
    nodejs_18.pkgs.yarn
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
    fixup-yarn-lock yarn.lock
    yarn install --frozen-lockfile --offline --no-progress --non-interactive
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
