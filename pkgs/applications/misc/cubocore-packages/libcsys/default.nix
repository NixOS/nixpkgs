{ mkDerivation, lib, fetchFromGitLab, udisks2, qtbase, cmake, ninja }:

mkDerivation rec {
  pname = "libcsys";
  version = "4.3.0";

  src = fetchFromGitLab {
    owner = "cubocore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/iRFppe08+rMQNFjWSyxo3Noy0iNaelg0JAczg/BYBs=";
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
