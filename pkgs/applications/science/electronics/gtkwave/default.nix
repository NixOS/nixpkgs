{stdenv, fetchurl, gtk, gperf, pkgconfig, bzip2} :
stdenv.mkDerivation rec {
  name = "gtkwave-3.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/gtkwave/${name}.tar.gz";
    sha256 = "0dccyyzk963v5nz6hxfvkcnfwm98m8d8s5x0nw6459r9683pdlri";
  };

  buildInputs = [ gtk gperf pkgconfig bzip2 ];

  meta = {
    description = "Wave viewer for Unix and Win32";
    homepage = http://gtkwave.sourceforge.net;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
