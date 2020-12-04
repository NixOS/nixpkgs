{ mkDerivation, lib, fetchFromGitHub, makeWrapper, cmake, qtbase, qttools, fftw, libusb1, libglvnd }:

mkDerivation rec {
  pname = "openhantek6022";
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "OpenHantek";
    repo = "OpenHantek6022";
    rev = version;
    sha256 = "0apbid2j1bqh5zd67ah8mq5dxq3r79lp8baj2fl481hxm2r3nvms";
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
    homepage    = "https://github.com/OpenHantek/OpenHantek6022";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ baracoder ];
    platforms = qtbase.meta.platforms;
  };
}
