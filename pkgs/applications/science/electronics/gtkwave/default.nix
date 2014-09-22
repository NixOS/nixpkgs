{stdenv, fetchurl, gtk, gperf, pkgconfig, bzip2, tcl, tk, judy, xz}:
stdenv.mkDerivation rec {
  name = "gtkwave-3.3.61";

  src = fetchurl {
    url = "mirror://sourceforge/gtkwave/${name}.tar.gz";
    sha256 = "1f8cw7xfr83mc5j6vq53jzzyw3n6pqdmrj4a7pm53m1wvjgk4w3v";
  };

  buildInputs = [ gtk gperf pkgconfig bzip2 tcl tk judy xz ];

  configureFlags = [ "--with-tcl=${tcl}/lib" "--with-tk=${tk}/lib" "--enable-judy" ];

  meta = {
    description = "Wave viewer for Unix and Win32";
    homepage = http://gtkwave.sourceforge.net;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
