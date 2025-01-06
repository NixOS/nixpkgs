{
  mkDerivation,
  lib,
  fetchFromGitLab,
  udisks2,
  qtbase,
  cmake,
  ninja,
}:

mkDerivation rec {
  pname = "libcsys";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1MHyx01w+dCeAeumcSXRBStgAec2yu1rLwaZaCXRgTc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    udisks2
  ];

  meta = {
    description = "Library for managing drive and getting system resource information in real time";
    homepage = "https://gitlab.com/cubocore/libcsys";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dan4ik605743 ];
    platforms = lib.platforms.linux;
  };
}
