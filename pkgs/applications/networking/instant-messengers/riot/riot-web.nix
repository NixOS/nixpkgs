{ lib, stdenv, fetchurl, writeText, conf ? null }:

let configFile = writeText "riot-config.json" conf; in
stdenv.mkDerivation rec {
  name= "riot-web-${version}";
  version = "0.16.0";

  src = fetchurl {
    url = "https://github.com/vector-im/riot-web/releases/download/v${version}/riot-v${version}.tar.gz";
    sha256 = "1nl0ih5flhp57k96hv6nl5pzrm3r9piqmwzirz9nz8k9803mqp5m";
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
