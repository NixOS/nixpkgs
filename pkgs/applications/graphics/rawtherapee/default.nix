{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, pixman, libpthreadstubs, gtkmm3, libXau
, libXdmcp, lcms2, libiptcdata, libcanberra-gtk3, fftw, expat, pcre, libsigcxx, wrapGAppsHook
, lensfun, librsvg, gtk-mac-integration
}:

stdenv.mkDerivation rec {
  version = "5.9";
  pname = "rawtherapee";

  src = fetchFromGitHub {
    owner = "Beep6581";
    repo = "RawTherapee";
    rev = version;
    sha256 = "sha256-kdctfjss/DHEcaSDPXcmT20wXTwkI8moRX/i/5wT5Hg=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook ];

  # Disable upstream-enforced bundling on macOS.
  patches = [ ./do-not-bundle.patch ];

  buildInputs = [
    pixman libpthreadstubs gtkmm3 libXau libXdmcp
    lcms2 libiptcdata fftw expat pcre libsigcxx lensfun librsvg
  ] ++ lib.optionals stdenv.isLinux [
    libcanberra-gtk3
  ] ++ lib.optionals stdenv.isDarwin [
    gtk-mac-integration
  ];

  cmakeFlags = [
    "-DPROC_TARGET_NUMBER=2"
    "-DCACHE_NAME_SUFFIX=\"\""
  ];

  CMAKE_CXX_FLAGS = "-std=c++11 -Wno-deprecated-declarations -Wno-unused-result";

  postUnpack = ''
    echo "set(HG_VERSION $version)" > $sourceRoot/ReleaseInfo.cmake
  '';

  meta = {
    description = "RAW converter and digital photo processing software";
    homepage = "http://www.rawtherapee.com/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jcumming mahe ];
    platforms = with lib.platforms; unix;
  };
}
