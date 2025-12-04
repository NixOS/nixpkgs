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
  inherit (pinData.hashes) webSrcHash webYarnHash webSharedComponentsYarnHash;
  noPhoningHome = {
    disable_guests = true; # disable automatic guest account registration at matrix.org
  };
  # Do not inherit jitsi-meet's knownVulnerabilities (libolm).
  # https://github.com/NixOS/nixpkgs/pull/335753
  # https://github.com/NixOS/nixpkgs/pull/334638
  jitsi-meet-override = jitsi-meet.overrideAttrs (previousAttrs: {
    meta = removeAttrs previousAttrs.meta [ "knownVulnerabilities" ];
  });
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

    # https://github.com/element-hq/element-web/commit/e883b05206129857aa00ca726252e10a0eb05cf9
    # introduced a link: dependency that we need to fetch as well
    offlineCacheSharedComponents = fetchYarnDeps {
      yarnLock = finalAttrs.src + "/packages/shared-components/yarn.lock";
      sha256 = webSharedComponentsYarnHash;
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

      pushd packages/shared-components
      yarnOfflineCache=${finalAttrs.offlineCacheSharedComponents} yarnConfigHook
      popd
      yarn --offline --cwd packages/shared-components prepare

      yarn --offline build:res
      yarn --offline build:module_system
      yarn --offline build:bundle

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -R webapp $out
      cp ${jitsi-meet-override}/libs/external_api.min.js $out/jitsi_external_api.min.js
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
