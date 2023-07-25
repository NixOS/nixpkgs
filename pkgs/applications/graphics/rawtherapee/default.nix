{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wrapGAppsHook
, makeWrapper
, pixman
, libpthreadstubs
, gtkmm3
, libXau
, libXdmcp
, lcms2
, libiptcdata
, fftw
, expat
, pcre
, libsigcxx
, lensfun
, librsvg
, libcanberra-gtk3
, gtk-mac-integration
}:

stdenv.mkDerivation rec {
  pname = "rawtherapee";
  version = "5.9";

  src = fetchFromGitHub {
    owner = "Beep6581";
    repo = "RawTherapee";
    rev = version;
    hash = "sha256-kdctfjss/DHEcaSDPXcmT20wXTwkI8moRX/i/5wT5Hg=";
  };

  postPatch = ''
    echo "set(HG_VERSION ${version})" > ReleaseInfo.cmake
    substituteInPlace tools/osx/Info.plist.in rtgui/config.h.in \
      --replace "/Applications" "${placeholder "out"}/Applications"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook
  ] ++ lib.optionals stdenv.isDarwin [
    makeWrapper
  ];

  buildInputs = [
    pixman
    libpthreadstubs
    gtkmm3
    libXau
    libXdmcp
    lcms2
    libiptcdata
    fftw
    expat
    pcre
    libsigcxx
    lensfun
    librsvg
  ] ++ lib.optionals stdenv.isLinux [
    libcanberra-gtk3
  ] ++ lib.optionals stdenv.isDarwin [
    gtk-mac-integration
  ];

  cmakeFlags = [
    "-DPROC_TARGET_NUMBER=2"
    "-DCACHE_NAME_SUFFIX=\"\""
  ] ++ lib.optionals stdenv.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=${stdenv.hostPlatform.darwinMinVersion}"
  ];

  CMAKE_CXX_FLAGS = toString [
    "-std=c++11"
    "-Wno-deprecated-declarations"
    "-Wno-unused-result"
  ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications/RawTherapee.app $out/bin
    cp -R Release $out/Applications/RawTherapee.app/Contents
    for f in $out/Applications/RawTherapee.app/Contents/MacOS/*; do
      makeWrapper $f $out/bin/$(basename $f)
    done
  '';

  meta = {
    description = "RAW converter and digital photo processing software";
    homepage = "http://www.rawtherapee.com/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jcumming mahe ];
    platforms = with lib.platforms; unix;
  };
}
