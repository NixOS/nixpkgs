{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
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

<<<<<<< HEAD
  meta = {
    description = "Tool for visualizing and communicating the errors in rendered images";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ zmitchell ];
=======
  meta = with lib; {
    description = "Tool for visualizing and communicating the errors in rendered images";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zmitchell ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "flip";
  };
}
