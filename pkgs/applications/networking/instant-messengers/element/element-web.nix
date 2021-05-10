{ lib, stdenv, fetchurl, writeText, jq, conf ? {} }:

# Note for maintainers:
# Versions of `element-web` and `element-desktop` should be kept in sync.

let
  noPhoningHome = {
    disable_guests = true; # disable automatic guest account registration at matrix.org
    piwik = false; # disable analytics
  };
  configOverrides = writeText "element-config-overrides.json" (builtins.toJSON (noPhoningHome // conf));

in stdenv.mkDerivation rec {
  pname = "element-web";
  version = "1.7.27";

  src = fetchurl {
    url = "https://github.com/vector-im/element-web/releases/download/v${version}/element-v${version}.tar.gz";
    sha256 = "004b1cjw8fqk0ixm0wnbk4y51cby1i7avsas95sfm2zsbnbwg519";
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
    maintainers = stdenv.lib.teams.matrix.members;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    hydraPlatforms = [];
  };
}
