{
  lib,
  stdenv,
  fetchurl,
  jq,
  jitsi-meet,
}:

let
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
  version = "1.12.32";

  src = fetchurl {
    url = "https://github.com/element-hq/element-web/releases/download/v${finalAttrs.version}/element-v${finalAttrs.version}.tar.gz";
    hash = "sha256-J1mcooXYXt2EHAS1xmLOTnc/VivJgJC0ueLVjP9rMIw=";
  };

  sourceRoot = "element-v${finalAttrs.version}";

  nativeBuildInputs = [ jq ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -R . $out
    cp ${jitsi-meet-override}/libs/external_api.min.js $out/jitsi_external_api.min.js
    echo "${finalAttrs.version}" > "$out/version"
    jq -s '.[0] * $conf' "config.sample.json" --argjson "conf" '${builtins.toJSON noPhoningHome}' > "$out/config.json"

    runHook postInstall
  '';

  meta = {
    description = "Matrix client for the web";
    homepage = "https://element.io/";
    changelog = "https://github.com/element-hq/element-web/blob/v${finalAttrs.version}/CHANGELOG.md";
    teams = [ lib.teams.matrix ];
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.all;
  };
})
