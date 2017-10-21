{stdenv, fetchFromGitHub, cmake, qtbase, qttools, qtsvg, qwt }:

stdenv.mkDerivation rec {
  name = "caneda-${version}";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Caneda";
    repo = "Caneda";
    rev = version;
    sha256 = "0hx8qid50j9xvg2kpbpqmbdyakgyjn6m373m1cvhp70v2gp1v8l2";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase qttools qtsvg qwt ];

  enableParallelBuilding = true;

  meta = {
    description = "Open source EDA software focused on easy of use and portability";
    homepage = http://caneda.org;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
