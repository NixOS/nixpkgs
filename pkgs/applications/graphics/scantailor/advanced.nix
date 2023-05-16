{ lib, fetchFromGitHub, mkDerivation
, cmake, libjpeg, libpng, libtiff, boost
, qtbase, qttools }:

mkDerivation rec {
  pname = "scantailor-advanced";
<<<<<<< HEAD
  version = "1.0.19";
=======
  version = "1.0.18";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vigri";
    repo = "scantailor-advanced";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-mvoCoYdRTgXW5t8yd9Y9TOl7D3RDVwcjUv2YDUWrtRI=";
=======
    sha256 = "sha256-4/QSjgHvRgIduS/AXbT7osRTdOdgR7On3CbjRnGbwHU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake qttools ];
  buildInputs = [ libjpeg libpng libtiff boost qtbase ];

  meta = with lib; {
    homepage = "https://github.com/vigri/scantailor-advanced";
    description = "Interactive post-processing tool for scanned pages (vigri's fork)";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jfrankenau ];
    platforms = with platforms; gnu ++ linux ++ darwin;
  };
}
