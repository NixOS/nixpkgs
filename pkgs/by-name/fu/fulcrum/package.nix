{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  python3,
  rocksdb_9_10,
  zeromq,
  libsForQt5,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fulcrum";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "cculianu";
    repo = "Fulcrum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ygUzDhqUDeoNgNNXjuIfcy1b5B1KxDGBV4dMdn83GR8=";
  };

  nativeBuildInputs = [
    pkg-config
    libsForQt5.qmake
  ];

  buildInputs = [
    python3
    libsForQt5.qtbase
    rocksdb_9_10
    zeromq
  ];

  dontWrapQtApps = true; # no GUI

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Fast & nimble SPV server for Bitcoin Cash & Bitcoin BTC";
    homepage = "https://github.com/cculianu/Fulcrum";
    maintainers = with lib.maintainers; [ prusnak ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "Fulcrum";
  };
})
