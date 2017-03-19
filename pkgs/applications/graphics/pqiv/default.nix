{ stdenv, fetchFromGitHub, getopt, which, pkgconfig, gtk2 } :

stdenv.mkDerivation (rec {
  name = "pqiv-${version}";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "phillipberndt";
    repo = "pqiv";
    rev = version;
    sha256 = "0fhmqa1q1y5y0ivrgx9xv864zqvd5dk4fiqi4bgi1ybdfx7vv2fy";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ getopt which gtk2 ];

  prePatch = "patchShebangs .";

  meta = with stdenv.lib; {
    description = "Rewrite of qiv (quick image viewer)";
    homepage = http://www.pberndt.com/Programme/Linux/pqiv;
    license = licenses.gpl3;
    maintainers = [ maintainers.ndowens ];
    platforms = platforms.unix;
  };
})
