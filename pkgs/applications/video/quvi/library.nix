{stdenv, fetchurl, pkgconfig, lua5, curl, quvi_scripts}:

stdenv.mkDerivation rec {
  name = "libquvi-${version}";
  version="0.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/quvi/libquvi-${version}.tar.gz";
    sha256 = "15cm9j8dssn2zhplqvlw49piwfw511lia6b635byiwfniqf6dnwp";
  };

  buildInputs = [ pkgconfig lua5 curl quvi_scripts ];

  meta = { 
    description = "Web video downloader";
    homepage = http://quvi.sf.net;
    license = "LGPLv2.1+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mornfall ]; 
  };
}

