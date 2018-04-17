{stdenv, fetchurl, gtk2, gperf, pkgconfig, bzip2, tcl, tk, judy, xz}:

stdenv.mkDerivation rec {
  name = "gtkwave-${version}";
  version = "3.3.89";

  src = fetchurl {
    url    = "mirror://sourceforge/gtkwave/${name}.tar.gz";
    sha256 = "1j7byy0kmapa66dp17gjvs4pa4gckjccljydixswdknpxs5ma45g";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 gperf bzip2 tcl tk judy xz ];

  configureFlags = [ "--with-tcl=${tcl}/lib" "--with-tk=${tk}/lib" "--enable-judy" ];

  meta = {
    description = "VCD/Waveform viewer for Unix and Win32";
    homepage    = http://gtkwave.sourceforge.net;
    license     = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice viric ];
    platforms   = stdenv.lib.platforms.linux;
  };
}
