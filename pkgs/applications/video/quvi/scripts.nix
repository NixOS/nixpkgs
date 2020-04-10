{stdenv, fetchurl, pkgconfig}:

stdenv.mkDerivation rec {
  pname = "quvi-scripts";
  version="0.9.20131130";

  src = fetchurl {
    url = "mirror://sourceforge/quvi/libquvi-scripts-${version}.tar.xz";
    sha256 = "1qvp6z5k1qgcys7vf7jd6fm0g07xixmciwj14ypn1kqhmjgizwhp";
  };

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Web video downloader";
    homepage = "http://quvi.sf.net";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}
