{stdenv, fetchurl, gtk, gperf, pkgconfig, bzip2} :
stdenv.mkDerivation rec {
  name = "gtkwave-3.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/gtkwave/${name}.tar.gz";
    sha256 = "1ym8fw6cv76gn80qzh6a5y7gikqgnz65hwy0cp6p6h18i5ghgfs0";
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
