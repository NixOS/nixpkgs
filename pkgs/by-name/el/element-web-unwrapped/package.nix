{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  jq,
  yarnConfigHook,
  nodejs,
  jitsi-meet,
}:

let
  pinData = import ./element-web-pin.nix;
  inherit (pinData.hashes) webSrcHash webYarnHash;
  noPhoningHome = {
    disable_guests = true; # disable automatic guest account registration at matrix.org
  };
in
stdenv.mkDerivation (
  finalAttrs:
  removeAttrs pinData [ "hashes" ]
  // {
    pname = "element-web";

    src = fetchFromGitHub {
      owner = "element-hq";
      repo = "element-web";
      rev = "v${finalAttrs.version}";
      hash = webSrcHash;
    };

    offlineCache = fetchYarnDeps {
      yarnLock = finalAttrs.src + "/yarn.lock";
      sha256 = webYarnHash;
    };

    nativeBuildInputs = [
      yarnConfigHook
      jq
      nodejs
    ];

    buildPhase = ''
      runHook preBuild

      export VERSION=${finalAttrs.version}
      yarn --offline build:res
      yarn --offline build:module_system
      yarn --offline build:bundle

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -R webapp $out
      tar --extract --to-stdout --file ${jitsi-meet.src} jitsi-meet/libs/external_api.min.js > $out/jitsi_external_api.min.js
      echo "${finalAttrs.version}" > "$out/version"
      jq -s '.[0] * $conf' "config.sample.json" --argjson "conf" '${builtins.toJSON noPhoningHome}' > "$out/config.json"

      runHook postInstall
    '';

    meta = {
      description = "Glossy Matrix collaboration client for the web";
      homepage = "https://element.io/";
      changelog = "https://github.com/element-hq/element-web/blob/v${finalAttrs.version}/CHANGELOG.md";
      teams = [ lib.teams.matrix ];
      license = lib.licenses.asl20;
      platforms = lib.platforms.all;
    };
  }
)
