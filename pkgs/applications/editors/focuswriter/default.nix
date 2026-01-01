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
<<<<<<< HEAD
  version = "1.8.13";
=======
  version = "1.8.11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "gottcode";
    repo = "focuswriter";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-lKhgfFPEcipQcW1S2+ntglVacH6dEcGpnNHvwgeVIzI=";
  };

=======
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

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Simple, distraction-free writing environment";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      madjar
      kashw2
    ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Simple, distraction-free writing environment";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      madjar
      kashw2
    ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://gottcode.org/focuswriter/";
    mainProgram = "focuswriter";
  };
}
