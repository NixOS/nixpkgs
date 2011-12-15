{stdenv, fetchurl, pkgconfig}:

stdenv.mkDerivation rec {
  name = "quvi-scripts-${version}";
  version="0.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/quvi/libquvi-scripts-${version}.tar.gz";
    sha256 = "14p1sn7id4n35isaw3i3h8vsgfqlym09fih9k5xfqwsg6n7xdvq5";
  };

  buildInputs = [ pkgconfig ];

  meta = { 
    description = "Quvi is a web video downloader.";
    homepage = http://quvi.sf.net;
    license = "LGPLv2.1+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mornfall ]; 
  };
}

