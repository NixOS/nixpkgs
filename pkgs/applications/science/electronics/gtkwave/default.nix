{stdenv, fetchurl, gtk, gperf, pkgconfig, bzip2, xz} :
stdenv.mkDerivation rec {
  name = "gtkwave-3.3.5";

  src = fetchurl {
    url = "mirror://sourceforge/gtkwave/${name}.tar.gz";
    sha256 = "0vll02l3g990spc7yzwl16lbw18ybm7s9j3ffjq2v7949wng43l9";
  };

  buildInputs = [ gtk gperf pkgconfig bzip2 xz ];

  meta = {
    description = "Wave viewer for Unix and Win32";
    homepage = http://gtkwave.sourceforge.net;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
