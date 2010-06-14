{stdenv, fetchurl, gtk, gperf, pkgconfig, bzip2, xz, tcl, tk, judy} :
stdenv.mkDerivation rec {
  name = "gtkwave-3.3.6";

  src = fetchurl {
    url = "mirror://sourceforge/gtkwave/${name}.tar.gz";
    sha256 = "0vlayjvhmijcg4pbjix9lm1d5n2wxzcn16lkm2ysgpc8q6987df8";
  };

  buildInputs = [ gtk gperf pkgconfig bzip2 xz tcl tk judy];

  configureFlags = [ "--with-tcl=${tcl}/lib" "--with-tk=${tk}/lib" "--enable-judy" ];

  meta = {
    description = "Wave viewer for Unix and Win32";
    homepage = http://gtkwave.sourceforge.net;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
