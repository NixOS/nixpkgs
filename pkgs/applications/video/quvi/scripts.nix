{lib, stdenv, fetchurl, pkg-config}:

stdenv.mkDerivation rec {
  pname = "quvi-scripts";
  version="0.9.20131130";

  src = fetchurl {
    url = "mirror://sourceforge/quvi/libquvi-scripts-${version}.tar.xz";
    sha256 = "1qvp6z5k1qgcys7vf7jd6fm0g07xixmciwj14ypn1kqhmjgizwhp";
  };

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Web video downloader";
    homepage = "http://quvi.sf.net";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    broken = true; # missing glibc-2.34 support, no upstream activity
  };
}
