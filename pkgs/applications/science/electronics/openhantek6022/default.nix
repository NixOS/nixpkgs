{ mkDerivation, lib, fetchFromGitHub, makeWrapper, cmake, qtbase, qttools, fftw, libusb1, libglvnd }:

mkDerivation rec {
  pname = "openhantek6022";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "OpenHantek";
    repo = "OpenHantek6022";
    rev = version;
    sha256 = "sha256-y2pNLAa0P/r0YEdKjQ3iP66cqtTWERG8lTOZDR64WTk=";
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
