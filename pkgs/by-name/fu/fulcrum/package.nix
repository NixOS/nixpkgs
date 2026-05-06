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
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "cculianu";
    repo = "Fulcrum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5DsZcnmqO8ZuD3+H/1lkfBrKeGq7efAjji0JDXTPQ1M=";
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
