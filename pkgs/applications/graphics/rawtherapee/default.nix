{ stdenv, fetchFromGitHub, pkgconfig, cmake, pixman, libpthreadstubs, gtkmm3, libXau
, libXdmcp, lcms2, libiptcdata, libcanberra-gtk3, fftw, expat, pcre, libsigcxx, wrapGAppsHook
, lensfun, librsvg
}:

stdenv.mkDerivation rec {
  version = "5.7";
  pname = "rawtherapee";

  src = fetchFromGitHub {
    owner = "Beep6581";
    repo = "RawTherapee";
    rev = version;
    sha256 = "0j3887a3683fqpvp66kaw6x81ai3gf5nvrbmb4cc8rb0lgj2xv2g";
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
