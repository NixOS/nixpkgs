{stdenv, fetchurl, gtk, gperf, pkgconfig, bzip2, tcl, tk, judy, xz}:
stdenv.mkDerivation rec {
  name = "gtkwave-3.3.39";

  src = fetchurl {
    url = "mirror://sourceforge/gtkwave/${name}.tar.gz";
    sha256 = "1va506anlbpbha7l6h94s44xjdy6ch22iv629swn4bh5m3qi33bg";
  };

  buildInputs = [ gtk gperf pkgconfig bzip2 tcl tk judy xz ];

  configureFlags = [ "--with-tcl=${tcl}/lib" "--with-tk=${tk}/lib" "--enable-judy" ];

  meta = {
    description = "Wave viewer for Unix and Win32";
    homepage = http://gtkwave.sourceforge.net;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
