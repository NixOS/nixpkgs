{ stdenv, fetchFromGitHub, pkgconfig, cmake, pixman, libpthreadstubs, gtkmm2, libXau
, libXdmcp, lcms2, libiptcdata, libcanberra_gtk2, fftw, expat, pcre, libsigcxx
}:

stdenv.mkDerivation rec {
  version = "5.0";
  name = "rawtherapee-" + version;

  src = fetchFromGitHub {
    owner = "Beep6581";
    repo = "RawTherapee";
    rev = "9fbbb052eefb739753f0f3d631e45694d659610a";
    sha256 = "0r8wzxp7q77g3hjz7dr5lh5wih762pgjad3lkzjfhki9lxr7ii7q";
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
