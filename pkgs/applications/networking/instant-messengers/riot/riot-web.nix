{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name= "riot-web-${version}";
  version = "0.12.2";

  src = fetchurl {
    url = "https://github.com/vector-im/riot-web/releases/download/v${version}/riot-v${version}.tar.gz";
    sha256 = "0zyddpnng1vjli12hn1hd0w99g6sfsk80dn2ll5h9276nc677pnh";
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
