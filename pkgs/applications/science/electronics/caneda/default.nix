{
  mkDerivation,
  lib,
  fetchFromGitHub,
  cmake,
  qtbase,
  qttools,
  qtsvg,
  qwt6_1,
}:

mkDerivation rec {
  pname = "caneda";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Caneda";
    repo = "Caneda";
    rev = version;
    sha256 = "sha256-oE0cdOwufc7CHEFr3YU8stjg1hBGs4bemhXpNTCTpDQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    qtbase
    qttools
    qtsvg
    qwt6_1
  ];

  meta = {
    description = "Open source EDA software focused on easy of use and portability";
    mainProgram = "caneda";
    homepage = "http://caneda.org";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
}
