{
  lib,
  stdenv,
  fetchFromGitHub,
  jq,
  nodejs,
  jitsi-meet,
  fetchPnpmDeps,
  pnpm_10,
  pnpmConfigHook,
  faketty,
}:

let
  pnpm = pnpm_10;

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
stdenv.mkDerivation (finalAttrs: {
  pname = "element-web";
  version = "1.12.14";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "element-web";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yy7CfMOMT1DBXHDHaDyAaOgp3s2KQIKA1A6zUhVOUhM=";
  };

  pnpmDeps = fetchPnpmDeps {
    pname = "element";
    inherit (finalAttrs) version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-0yqWObZtRntsH7gk+OB8pMuWsrvCQ4L9173Qv0o5abk=";
  };

  nativeBuildInputs = [
    jq
    nodejs
    pnpm
    pnpmConfigHook
    faketty
  ];

  # faketty is required to work around a bug in nx.
  # See: https://github.com/nrwl/nx/issues/22445
  buildPhase = ''
    runHook preBuild

    cd apps/web

    export VERSION=${finalAttrs.version}
    faketty pnpm run build

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
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.all;
  };
})
