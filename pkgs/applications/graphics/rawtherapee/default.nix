{ stdenv, fetchFromGitHub, pkgconfig, cmake, pixman, libpthreadstubs, gtkmm2, libXau
, libXdmcp, lcms2, libiptcdata, libcanberra_gtk2, fftw, expat, pcre, libsigcxx
}:

stdenv.mkDerivation rec {
  version = "5.0-r1";
  name = "rawtherapee-" + version;

  src = fetchFromGitHub {
    owner = "Beep6581";
    repo = "RawTherapee";
    rev = "1077c4ba2e2dbe249884e6974c6050db8eb5e9c2";
    sha256 = "1xqmkwprk3h9nhy6q562mkjdpynyg9ff7a92sdga50k56gi0aj0s";
  };

  buildInputs = [
    pkgconfig cmake pixman libpthreadstubs gtkmm2 libXau libXdmcp
    lcms2 libiptcdata libcanberra_gtk2 fftw expat pcre libsigcxx
  ];

  cmakeFlags = [
    "-DPROC_TARGET_NUMBER=2"
  ];

  CMAKE_CXX_FLAGS = "-std=c++11 -Wno-deprecated-declarations -Wno-unused-result";

  postUnpack = ''
    echo "set(HG_VERSION $version)" > $sourceRoot/ReleaseInfo.cmake
  '';

  enableParallelBuilding = true;

  meta = {
    description = "RAW converter and digital photo processing software";
    homepage = http://www.rawtherapee.com/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ viric jcumming mahe the-kenny ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
