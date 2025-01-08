{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  cmake,
  hunspell,
  qtbase,
  qtmultimedia,
  qttools,
  qt5compat,
  qtwayland,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "focuswriter";
  version = "1.8.9";

  src = fetchFromGitHub {
    owner = "gottcode";
    repo = "focuswriter";
    rev = "v${version}";
    hash = "sha256-FFfNjjVwi0bE6oc8LYhXrCKd+nwRQrjWzK5P4DSIIgs=";
  };

  patches = [
    # Respect DICPATH when searching for available languages for spell checking
    # Remove with the next release
    (fetchpatch {
      name = "focuswriter-respect-dicpath.patch";
      url = "https://github.com/gottcode/focuswriter/commit/520a6a3858ab6a6f0ed264c27df83d93e6aa866e.patch";
      hash = "sha256-dwyFDy4kyKF0Fdp0oC0NiAykASdKI0KD+zrCH7raTYI=";
    })
    (fetchpatch {
      name = "focuswriter-respect-dicpath-windows.patch";
      url = "https://github.com/gottcode/focuswriter/commit/2b0f9ac1effdb0ddb63532e7ce392f5ad041433d.patch";
      hash = "sha256-iADIEH7VzSEqYjTyWCTitexCaePFmPDl/YHETfU+rpw=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    hunspell
    qtbase
    qtmultimedia
    qt5compat
    qtwayland
  ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = with lib; {
    description = "Simple, distraction-free writing environment";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      madjar
      kashw2
    ];
    platforms = platforms.linux;
    homepage = "https://gottcode.org/focuswriter/";
    mainProgram = "focuswriter";
  };
}
