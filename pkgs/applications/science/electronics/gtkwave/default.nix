{stdenv, fetchurl, gtk2, gperf, pkgconfig, bzip2, tcl, tk, judy, xz}:

stdenv.mkDerivation rec {
  pname = "gtkwave";
  version = "3.3.102";

  src = fetchurl {
    url    = "mirror://sourceforge/gtkwave/${pname}-${version}.tar.gz";
    sha256 = "1izyfx6b1n9nr08c7q0gkgcf0q04bb4qz92ckwh74n5l5nwprfw0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 gperf bzip2 tcl tk judy xz ];

  configureFlags = [ "--with-tcl=${tcl}/lib" "--with-tk=${tk}/lib" "--enable-judy" ];

  meta = {
    description = "VCD/Waveform viewer for Unix and Win32";
    homepage    = http://gtkwave.sourceforge.net;
    license     = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
    platforms   = stdenv.lib.platforms.linux;
  };
}
