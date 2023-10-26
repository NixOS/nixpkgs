{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake
}:

stdenv.mkDerivation {
  pname = "flip";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "NVlabs";
    repo = "flip";
    rev = "8303adb2060d69423d040453995f4ad1a030a1cc";
    hash = "sha256-jSB79qOtnW/cjApIDcLRqGabnzCIwS7saA+aF1TcyV0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A tool for visualizing and communicating the errors in rendered images.";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zmitchell ];
    mainProgram = "flip";
  };
}
