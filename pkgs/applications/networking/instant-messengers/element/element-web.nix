{ lib
, stdenv
, runCommand
, fetchFromGitHub
, fetchYarnDeps
, writeText
, jq
, yarn
, fixup_yarn_lock
, nodejs
, jitsi-meet
, conf ? { }
}:

let
  pinData = lib.importJSON ./pin.json;
  noPhoningHome = {
    disable_guests = true; # disable automatic guest account registration at matrix.org
    piwik = false; # disable analytics
  };
  configOverrides = writeText "element-config-overrides.json" (builtins.toJSON (noPhoningHome // conf));

in stdenv.mkDerivation rec {
  pname = "element-web";
  inherit (pinData) version;

  src = fetchFromGitHub {
    owner = "vector-im";
    repo = pname;
    rev = "v${version}";
    sha256 = pinData.webSrcHash;
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = pinData.webYarnHash;
  };

  nativeBuildInputs = [ yarn fixup_yarn_lock jq nodejs ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$PWD/tmp
    mkdir -p $HOME

    fixup_yarn_lock yarn.lock
    yarn config --offline set yarn-offline-mirror $offlineCache
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export VERSION=${version}
    yarn build:res --offline
    yarn build:module_system --offline
    yarn build:bundle --offline

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -R webapp $out
    cp ${jitsi-meet}/libs/external_api.min.js $out/jitsi_external_api.min.js
    echo "${version}" > "$out/version"
    jq -s '.[0] * .[1]' "config.sample.json" "${configOverrides}" > "$out/config.json"

    runHook postInstall
  '';

  meta = {
    description = "A glossy Matrix collaboration client for the web";
    homepage = "https://element.io/";
    changelog = "https://github.com/vector-im/element-web/blob/v${version}/CHANGELOG.md";
    maintainers = lib.teams.matrix.members;
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
