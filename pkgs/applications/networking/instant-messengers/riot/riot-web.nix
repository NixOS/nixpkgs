{ lib, stdenv, fetchurl, writeText, conf ? null }:

# Note for maintainers:
# Versions of `riot-web` and `riot-desktop` should be kept in sync.

let configFile = writeText "riot-config.json" conf; in
stdenv.mkDerivation rec {
  name= "riot-web-${version}";
  version = "1.2.2";

  src = fetchurl {
    url = "https://github.com/vector-im/riot-web/releases/download/v${version}/riot-v${version}.tar.gz";
    sha256 = "19nb6gyjaijah068ika6hvk18hraivm71830i9cd4ssl6g5j4k8x";
  };

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
    ${lib.optionalString (conf != null) "ln -s ${configFile} $out/config.json"}
  '';

  meta = {
    description = "A glossy Matrix collaboration client for the web";
    homepage = http://riot.im/;
    maintainers = with stdenv.lib.maintainers; [ bachp pacien ];
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    hydraPlatforms = [];
  };
}
