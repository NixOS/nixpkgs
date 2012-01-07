{ stdenv, fetchurl, autoconf, automake, libtool, qt3, pkgconfig
, openssl, libpng, alsaLib, libX11, libXext, libXt, libICE
, libSM }:

stdenv.mkDerivation {
  name = "kphone-1.2";

  src = fetchurl {
    url = mirror://sourceforge/kphone/kphoneSI_1.2.tar.gz;
    sha256 = "1q309n2gsdsa8d7ff2zwnyc69ngpnnj143dys90dnlmzr9ckhhg3";
  };

  buildInputs =
    [ autoconf automake libtool qt3 pkgconfig openssl libpng alsaLib
      libX11 libXext libXt libICE libSM
    ];
    
  preConfigure = "autoconf";

  meta = {
    description = "KPhone is a SIP UA for Linux";
    homepage = http://sourceforge.net/projects/kphone/;
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
