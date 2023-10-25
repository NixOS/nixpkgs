{ stdenv, lib
, fetchFromGitHub
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

  src = fetchFromGitHub {
    owner = "SchildiChat";
    repo = "schildichat-desktop";
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
    # with the update of openssl3, some key ciphers are not supported anymore
    # this flag will allow those codecs again as a workaround
    # see https://medium.com/the-node-js-collection/node-js-17-is-here-8dba1e14e382#5f07
    # and https://github.com/vector-im/element-web/issues/21043
    export NODE_OPTIONS=--openssl-legacy-provider
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

    pushd element-web
    export VERSION=${version}
    yarn build:res --offline
    yarn build:module_system --offline
    yarn build:bundle --offline
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mv element-web/webapp $out
    jq -s '.[0] * .[1]' "configs/sc/config.json" "${configOverrides}" > "$out/config.json"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Matrix client / Element Web fork";
    homepage = "https://schildi.chat/";
    changelog = "https://github.com/SchildiChat/schildichat-desktop/releases";
    maintainers = teams.matrix.members ++ (with maintainers; [ kloenk yuka ]);
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
