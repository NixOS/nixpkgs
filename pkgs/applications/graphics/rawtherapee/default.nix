{ stdenv, fetchFromGitHub, pkgconfig, cmake, pixman, libpthreadstubs, gtkmm3, libXau
, libXdmcp, lcms2, libiptcdata, libcanberra-gtk3, fftw, expat, pcre, libsigcxx, wrapGAppsHook
, lensfun
}:

stdenv.mkDerivation rec {
  version = "5.4";
  name = "rawtherapee-" + version;

  src = fetchFromGitHub {
    owner = "Beep6581";
    repo = "RawTherapee";
    rev = version;
    sha256 = "1h2x5biqsb4kfwsffqkyk8ky22qv2a0cjs1s445x9farcr3kwk99";
  };

  nativeBuildInputs = [ cmake pkgconfig wrapGAppsHook ];

  buildInputs = [
    pixman libpthreadstubs gtkmm3 libXau libXdmcp
    lcms2 libiptcdata libcanberra-gtk3 fftw expat pcre libsigcxx lensfun
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
    maintainers = with stdenv.lib.maintainers; [ viric jcumming mahe the-kenny ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
