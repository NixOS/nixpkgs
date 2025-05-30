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
  version = "1.8.11";

  src = fetchFromGitHub {
    owner = "gottcode";
    repo = "focuswriter";
    rev = "v${version}";
    hash = "sha256-oivhrDF3HikbEtS1cOlHwmQYNYf3IkX+gQGW0V55IWU=";
  };

  patches = [
    # Fix build, remove at next version bump
    # https://github.com/gottcode/focuswriter/pull/208
    (fetchpatch {
      url = "https://github.com/gottcode/focuswriter/commit/dd74ed4559a141653a06e7984c1251b992925775.diff";
      hash = "sha256-1bxa91xnkF1MIQlA8JgwPHW/A80ThbVVdVtusmzd22I=";
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
