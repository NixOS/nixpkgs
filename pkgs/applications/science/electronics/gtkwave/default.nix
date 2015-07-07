{stdenv, fetchurl, gtk, gperf, pkgconfig, bzip2, tcl, tk, judy, xz}:
stdenv.mkDerivation rec {
  name = "gtkwave-3.3.66";

  src = fetchurl {
    url = "mirror://sourceforge/gtkwave/${name}.tar.gz";
    sha256 = "17mrmgr6zzl1x1qml0wmjjhcbw7bg3w4mqy60rsy0z6gxd8hikh4";
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
