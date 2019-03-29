{ lib, stdenv, fetchurl, writeText, conf ? null }:

let configFile = writeText "riot-config.json" conf; in
stdenv.mkDerivation rec {
  name= "riot-web-${version}";
  version = "1.0.5";

  src = fetchurl {
    url = "https://github.com/vector-im/riot-web/releases/download/v${version}/riot-v${version}.tar.gz";
    sha256 = "0m0kdnw0pc84yasnybfh9hmkajji0wjk2snv89crdi79s8k572ki";
  };

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
    ${lib.optionalString (conf != null) "ln -s ${configFile} $out/config.json"}
  '';

  meta = {
    description = "A glossy Matrix collaboration client for the web";
    homepage = http://riot.im/;
    maintainers = with stdenv.lib.maintainers; [ bachp ];
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    hydraPlatforms = [];
  };
}
