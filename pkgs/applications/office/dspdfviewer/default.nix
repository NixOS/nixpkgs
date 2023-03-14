{ stdenv
, fetchFromGitHub
, boost
, libsForQt5
, qt5
, cmake
, pkg-config
, lib
}:

stdenv.mkDerivation rec {
  pname = "dspdfviewer";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "dannyedel";
    repo = "dspdfviewer";
    rev = "v${version}";
    hash = "sha256-NDjbr7kWQP1OkikveLWlGCZzJUF0u1+dnzaeE32MK1g=";
  };

  cmakeFlags = [
    "-DDCMAKE_BUILD_TYPE=Release"
    "-DUsePrerenderedPDF=ON"
    "-DCMAKE_CXX_FLAGS_INIT=\"-Wno-error=deprecated-declarations\" "
  ];
  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
  ];

  buildInputs = [
    boost
    libsForQt5.poppler
    qt5.qtbase
    qt5.qttools
    qt5.wrapQtAppsHook
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = with lib; {
    description = " Dual-Screen PDF Viewer for latex-beamer";
    homepage = "https://dspdfviewer.danny-edel.de/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ e1mo ];
    changelog = "https://github.com/dannyedel/dspdfviewer/blob/v${version}/CHANGELOG.md";
    platforms = [ "x86_64-linux" "aarch64-linux" ]; # Offborg builds fail on aarch64-darwin, x86_64-darwin. I'm unable to test/debug this
  };
}
