{ lib, stdenv, fetchFromGitHub, libjpeg }:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "1.5.5";
=======
  version = "1.5.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "jpegoptim";

  src = fetchFromGitHub {
    owner = "tjko";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-3p3kcUur1u09ROdKXG5H8eilu463Rzbn2yfYo5o6+KM=";
=======
    sha256 = "sha256-vNjXY/Qz6IT7rV+as2EBkSWd4O98slcXLNgAO9Dkc9E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # There are no checks, it seems.
  doCheck = false;

  buildInputs = [ libjpeg ];

  meta = with lib; {
    description = "Optimize JPEG files";
    homepage = "https://www.kokkonen.net/tjko/projects.html";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.aristid ];
    platforms = platforms.all;
  };
}
