{ lib
, mkYarnPackage
, runCommand
, fetchFromGitHub
, fetchYarnDeps
, writeText
, jq
, yarn
, fixup_yarn_lock
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

in
mkYarnPackage rec {
  pname = "element-web";
  inherit (pinData) version;

  src = fetchFromGitHub {
    owner = "vector-im";
    repo = pname;
    rev = "v${version}";
    sha256 = pinData.webSrcHash;
  };

  packageJSON = ./element-web-package.json;
  # Remove the matrix-analytics-events dependency from the matrix-react-sdk
  # dependencies list. It doesn't seem to be necessary since we already are
  # installing it individually, and it causes issues with the offline mode.
  yarnLock = (runCommand "${pname}-modified-lock" {} ''
    sed '/matrix-analytics-events "github/d' ${src}/yarn.lock > "$out"
  '');
  offlineCache = fetchYarnDeps {
    inherit yarnLock;
    sha256 = pinData.webYarnHash;
  };

  nativeBuildInputs = [ jq ];

  configurePhase = ''
    runHook preConfigure
    ln -s $node_modules node_modules
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export VERSION=${version}
    yarn build:res --offline
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

  # Do not attempt generating a tarball for element-web again.
  doDist = false;

  meta = {
    description = "A glossy Matrix collaboration client for the web";
    homepage = "https://element.io/";
    changelog = "https://github.com/vector-im/element-web/blob/v${version}/CHANGELOG.md";
    maintainers = lib.teams.matrix.members;
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
