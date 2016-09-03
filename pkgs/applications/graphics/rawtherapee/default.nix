{ stdenv, fetchFromGitHub, pkgconfig, cmake, pixman, libpthreadstubs, gtkmm2, libXau
, libXdmcp, lcms2, libiptcdata, libcanberra_gtk2, fftw, expat, pcre, libsigcxx
}:

stdenv.mkDerivation rec {
  version = "4.2.1025";
  name = "rawtherapee-" + version;

  src = fetchFromGitHub {
    owner = "Beep6581";
    repo = "RawTherapee";
    rev = "dc4bbe906ba92ddc66f98a3c26ce19822bfb99ab";
    sha256 = "0c5za9s8533fiyl32378dq9rgd5044xi8y0wm2gkr7krbdnx74l3";
  };

  buildInputs = [ pkgconfig cmake pixman libpthreadstubs gtkmm2 libXau libXdmcp
    lcms2 libiptcdata libcanberra_gtk2 fftw expat pcre libsigcxx ];

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
