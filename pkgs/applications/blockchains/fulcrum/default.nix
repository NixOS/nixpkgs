{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qmake,
  python3,
  qtbase,
  rocksdb_7_10,
  zeromq,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fulcrum";
  version = "1.12.0.1";

  src = fetchFromGitHub {
    owner = "cculianu";
    repo = "Fulcrum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/RlvbZ6/f0Jxj6oCeHjGWqlktvtNUNczOXi2/wYw2LQ=";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
  ];

  buildInputs = [
    python3
    qtbase
    rocksdb_7_10
    zeromq
  ];

  dontWrapQtApps = true; # no GUI

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast & nimble SPV server for Bitcoin Cash & Bitcoin BTC";
    homepage = "https://github.com/cculianu/Fulcrum";
    maintainers = with lib.maintainers; [ prusnak ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
