{ mkDerivation, lib, fetchFromGitHub, makeWrapper, cmake, qtbase, qttools, fftw, libusb1, libglvnd }:

mkDerivation rec {
  pname = "openhantek6022";
<<<<<<< HEAD
  version = "3.3.3";
=======
  version = "3.3.2.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "OpenHantek";
    repo = "OpenHantek6022";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-y2pNLAa0P/r0YEdKjQ3iP66cqtTWERG8lTOZDR64WTk=";
=======
    sha256 = "sha256-0k9Q60+T28m1hPYf5viSdpt0s4d828lfjVo3GjLDm7c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ fftw libusb1 libglvnd qtbase qttools ];

  postPatch = ''
    # Fix up install paths & checks
    sed -i 's#if(EXISTS ".*")#if(1)#g' CMakeLists.txt
    sed -i 's#/lib/udev#lib/udev#g' CMakeLists.txt
    sed -i 's#/usr/share#share#g' CMakeLists.txt
  '';

  meta = with lib; {
    description = "Free software for Hantek and compatible (Voltcraft/Darkwire/Protek/Acetech) USB digital signal oscilloscopes";
    homepage = "https://github.com/OpenHantek/OpenHantek6022";
    license = licenses.gpl3;
    maintainers = with maintainers; [ baracoder ];
    platforms = qtbase.meta.platforms;
  };
}
