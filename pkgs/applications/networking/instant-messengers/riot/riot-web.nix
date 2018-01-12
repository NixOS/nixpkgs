{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name= "riot-web-${version}";
  version = "0.13.3";

  src = fetchurl {
    url = "https://github.com/vector-im/riot-web/releases/download/v${version}/riot-v${version}.tar.gz";
    sha256 = "0acim3kad6lv5ni4blg75phb3njyk9s5h6x7fsn151h1pvsc5mmw";
  };

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
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
