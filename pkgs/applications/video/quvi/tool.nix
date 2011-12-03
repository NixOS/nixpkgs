{stdenv, fetchurl, pkgconfig, lua5, curl, quvi_scripts, libquvi}:

stdenv.mkDerivation rec {
  name = "quvi-${version}";
  version="0.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/quvi/quvi-${version}.tar.gz";
    sha256 = "0qzyj55py4z7pg97794jjycq8nvrlr02072rgjzg8jgknw49hgfv";
  };

  buildInputs = [ pkgconfig lua5 curl quvi_scripts libquvi ];

  meta = { 
    description = "Quvi is a web video downloader.";
    homepage = http://quvi.sf.net;
    license = "LGPLv2.1+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mornfall ]; 
  };
}

