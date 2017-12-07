{ stdenv, fetchurl, pkgconfig, libX11, libXpm, libXext, libXfixes, libXmu }:

stdenv.mkDerivation {
  name = "wmsystemtray-1.4";
  src = fetchurl {
     url = mirror://sourceforge/project/wmsystemtray/wmsystemtray/wmsystemtray-1.4.tar.gz;
     sha256 = "8edef43691e9fff071000e29166c7c1ad420c0956e9068151061e881c8ac97e9";
  };

  buildInputs = [ pkgconfig libX11 libXpm libXext libXfixes libXmu ];

  meta = {
    description = "Systemtray for Windowmaker";
    homepage = http://wmsystemtray.sourceforge.net;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.bstrik ];
    platforms = stdenv.lib.platforms.linux;
  };
}
