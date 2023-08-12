{ mkDerivation, lib, fetchFromGitLab, udisks2, qtbase, cmake, ninja }:

mkDerivation rec {
  pname = "libcsys";
  version = "4.4.1";

  src = fetchFromGitLab {
    owner = "cubocore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IWzgRwouI/0bQBuEd9CV0Ue6cF2HwRw3jMdLyGA1+TY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    udisks2
  ];

  meta = with lib; {
    description = "Library for managing drive and getting system resource information in real time";
    homepage = "https://gitlab.com/cubocore/libcsys";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
