{ stdenv, fetchFromGitHub, pkgconfig, cmake, pixman, libpthreadstubs, gtkmm3, libXau
, libXdmcp, lcms2, libiptcdata, libcanberra_gtk3, fftw, expat, pcre, libsigcxx, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  version = "5.0-r1";
  name = "rawtherapee-" + version;

  src = fetchFromGitHub {
    owner = "Beep6581";
    repo = "RawTherapee";
    rev = version + "-gtk3";
    sha256 = "06v3ir5562yg4zk9z8kc8a7sw7da88193sizjlk74gh5d3smgr4q";
  };

  buildInputs = [
    pkgconfig cmake pixman libpthreadstubs gtkmm3 libXau libXdmcp
    lcms2 libiptcdata libcanberra_gtk3 fftw expat pcre libsigcxx
  ];

  nativeBuildInputs = [ wrapGAppsHook ];

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
