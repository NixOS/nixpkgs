{ mkDerivation, lib, fetchFromGitHub, cmake, qtbase, qttools, qtsvg, qwt6_1}:

mkDerivation rec {
  pname = "caneda";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Caneda";
    repo = "Caneda";
    rev = version;
    sha256 = "0hx8qid50j9xvg2kpbpqmbdyakgyjn6m373m1cvhp70v2gp1v8l2";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase qttools qtsvg qwt6_1 ];

  meta = {
    description = "Open source EDA software focused on easy of use and portability";
    mainProgram = "caneda";
    homepage = "http://caneda.org";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
}
