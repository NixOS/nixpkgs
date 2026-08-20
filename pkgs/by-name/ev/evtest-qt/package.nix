{
  lib,
  stdenv,
  cmake,
  libsForQt5,
  fetchFromGitHub,
  fetchpatch,
  unstableGitUpdater,
  pkg-config,
  libevdev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "evtest-qt";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Grumbel";
    repo = "evtest-qt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ea0STAFjrP/0cx/+0kjolqvGdRnQxouA2w4JUhYueY8=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    libsForQt5.qtbase
    libevdev
  ];

  meta = {
    description = "Simple input device tester for linux with Qt GUI";
    mainProgram = "evtest-qt";
    homepage = "https://github.com/Grumbel/evtest-qt";
    maintainers = with lib.maintainers; [
      alexarice
      lukas-sgx
    ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
})
