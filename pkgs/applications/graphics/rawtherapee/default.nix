{ stdenv, fetchFromGitHub, pkgconfig, cmake, pixman, libpthreadstubs, gtkmm3, libXau
, libXdmcp, lcms2, libiptcdata, libcanberra-gtk3, fftw, expat, pcre, libsigcxx, wrapGAppsHook
, lensfun, librsvg
}:

stdenv.mkDerivation rec {
  version = "5.8";
  pname = "rawtherapee";

  src = fetchFromGitHub {
    owner = "Beep6581";
    repo = "RawTherapee";
    rev = version;
    sha256 = "0d644s4grfia6f3k6y0byd5pwajr12kai2kc280yxi8v3w1b12ik";
  };

  nativeBuildInputs = [ cmake pkgconfig wrapGAppsHook ];

  buildInputs = [
    pixman libpthreadstubs gtkmm3 libXau libXdmcp
    lcms2 libiptcdata libcanberra-gtk3 fftw expat pcre libsigcxx lensfun librsvg
  ];

  cmakeFlags = [
    "-DPROC_TARGET_NUMBER=2"
    "-DCACHE_NAME_SUFFIX=\"\""
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
    maintainers = with stdenv.lib.maintainers; [ jcumming mahe the-kenny ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
