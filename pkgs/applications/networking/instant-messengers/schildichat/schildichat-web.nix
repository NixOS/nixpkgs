{ stdenv, lib
, fetchgit
, fetchYarnDeps
, nodejs
, yarn
, fixup_yarn_lock
, writeText, jq, conf ? {}
}:

let
  pinData = lib.importJSON ./pin.json;
  noPhoningHome = {
    disable_guests = true; # disable automatic guest account registration at matrix.org
  };
  configOverrides = writeText "element-config-overrides.json" (builtins.toJSON (noPhoningHome // conf));

in stdenv.mkDerivation rec {
  pname = "schildichat-web";
  inherit (pinData) version;

  src = fetchgit {
    url = "https://github.com/SchildiChat/schildichat-desktop/";
    inherit (pinData) rev;
    sha256 = pinData.srcHash;
    fetchSubmodules = true;
  };

  webOfflineCache = fetchYarnDeps {
    yarnLock = src + "/element-web/yarn.lock";
    sha256 = pinData.webYarnHash;
  };
  jsSdkOfflineCache = fetchYarnDeps {
    yarnLock = src + "/matrix-js-sdk/yarn.lock";
    sha256 = pinData.jsSdkYarnHash;
  };
  reactSdkOfflineCache = fetchYarnDeps {
    yarnLock = src + "/matrix-react-sdk/yarn.lock";
    sha256 = pinData.reactSdkYarnHash;
  };

  nativeBuildInputs = [ yarn fixup_yarn_lock jq nodejs ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$PWD/tmp
    mkdir -p $HOME

    pushd element-web
    fixup_yarn_lock yarn.lock
    yarn config --offline set yarn-offline-mirror $webOfflineCache
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules
    rm -rf node_modules/matrix-react-sdk
    ln -s $PWD/../matrix-react-sdk node_modules/
    rm -rf node_modules/matrix-js-sdk
    ln -s $PWD/../matrix-js-sdk node_modules/
    popd

    pushd matrix-js-sdk
    fixup_yarn_lock yarn.lock
    yarn config --offline set yarn-offline-mirror $jsSdkOfflineCache
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules
    popd

    pushd matrix-react-sdk
    fixup_yarn_lock yarn.lock
    yarn config --offline set yarn-offline-mirror $reactSdkOfflineCache
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules scripts
    popd

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    pushd matrix-react-sdk
    ../element-web/node_modules/.bin/reskindex -h ../element-web/src/header
    popd

    pushd element-web
    node scripts/copy-res.js
    node_modules/.bin/reskindex -h ../element-web/src/header
    node_modules/.bin/webpack --progress --mode production
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mv element-web/webapp $out
    jq -s '.[0] * .[1]' "configs/sc/config.json" "${configOverrides}" > "$out/config.json"

    runHook postInstall
  '';

  meta = {
    description = "Matrix client / Element Web fork";
    homepage = "https://schildi.chat/";
    changelog = "https://github.com/SchildiChat/schildichat-desktop/releases";
    maintainers = lib.teams.matrix.members ++ [ lib.maintainers.kloenk ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
