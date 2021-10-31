{ lib, stdenv, fetchurl, writeText, jq, conf ? {} }:

let
  pinData = (builtins.fromJSON (builtins.readFile ./pin.json));
  noPhoningHome = {
    disable_guests = true; # disable automatic guest account registration at matrix.org
    piwik = false; # disable analytics
  };
  configOverrides = writeText "element-config-overrides.json" (builtins.toJSON (noPhoningHome // conf));

in stdenv.mkDerivation rec {
  pname = "element-web";
  inherit (pinData) version;

  src = fetchurl {
    url = "https://github.com/vector-im/element-web/releases/download/v${version}/element-v${version}.tar.gz";
    sha256 = pinData.webHash;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -R . $out/
    ${jq}/bin/jq -s '.[0] * .[1]' "config.sample.json" "${configOverrides}" > "$out/config.json"

    runHook postInstall
  '';

  meta = {
    description = "A glossy Matrix collaboration client for the web";
    homepage = "https://element.io/";
    changelog = "https://github.com/vector-im/element-web/blob/v${version}/CHANGELOG.md";
    maintainers = lib.teams.matrix.members;
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    hydraPlatforms = [];
  };
}
