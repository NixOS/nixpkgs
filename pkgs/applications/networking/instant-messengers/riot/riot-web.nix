{ lib, stdenv, fetchurl, writeText, jq, conf ? {} }:

# Note for maintainers:
# Versions of `riot-web` and `riot-desktop` should be kept in sync.

let
  noPhoningHome = {
    disable_guests = true; # disable automatic guest account registration at matrix.org
    piwik = false; # disable analytics
  };
  configOverrides = writeText "riot-config-overrides.json" (builtins.toJSON (noPhoningHome // conf));

in stdenv.mkDerivation rec {
  pname = "riot-web";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/vector-im/riot-web/releases/download/v${version}/riot-v${version}.tar.gz";
    sha256 = "1mm4xk69ya1k3gz6jjhc4njx7b3rp157jmrqsxr5i382zs035ff7";
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
    homepage = "http://riot.im/";
    maintainers = with stdenv.lib.maintainers; [ bachp pacien ma27 ];
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    hydraPlatforms = [];
  };
}
