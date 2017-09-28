{ stdenv, fetchFromGitHub, pkgconfig, cmake, pixman, libpthreadstubs, gtkmm3, libXau
, libXdmcp, lcms2, libiptcdata, libcanberra_gtk3, fftw, expat, pcre, libsigcxx, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  version = "5.2";
  name = "rawtherapee-" + version;

  src = fetchFromGitHub {
    owner = "Beep6581";
    repo = "RawTherapee";
    rev = version;
    sha256 = "0i3cr3335bw8yxxzn6kcdx6ccinlnxzrdbgl3ld1kym1w2n5449k";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [
    cmake pixman libpthreadstubs gtkmm3 libXau libXdmcp
    lcms2 libiptcdata libcanberra_gtk3 fftw expat pcre libsigcxx
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
