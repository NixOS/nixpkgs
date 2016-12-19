{ stdenv, fetchurl, libjack2, gtk2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "bitmeter-${version}";
  version = "1.2";

  src = fetchurl {
    url = "http://devel.tlrmx.org/audio/source/${name}.tar.gz";
    sha256 = "09ck2gxqky701dc1p0ip61rrn16v0pdc7ih2hc2sd63zcw53g2a7";
  };

  buildInputs = [ libjack2 gtk2 pkgconfig ];

  meta = with stdenv.lib; {
    homepage = http://devel.tlrmx.org/audio/bitmeter/;
    description = "Also known as jack bitscope. Useful to detect denormals";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
