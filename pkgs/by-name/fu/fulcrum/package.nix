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

let
  # Fulcrum uses Qt Core and Network. Trim optional dependencies from its
  # private Qt build to reduce the server's closure.
  qtbase = libsForQt5.qtbase.override {
    # Neither printing nor GTK integration is needed. GTK would also bring
    # CUPS back in indirectly if only Qt's direct CUPS dependency were removed.
    cups = null;
    withGtk3 = false;

    # Translations are built with Qt tools that use another Qt build with CUPS
    # support, so disable them to keep CUPS out of the build dependencies too.
    qttranslations = null;

    # Fulcrum uses RocksDB, so it does not need Qt's MySQL or PostgreSQL drivers.
    mysqlSupport = false;
    libpq = null;
  };

  # qmake propagates qtbase.dev. Use the same Qt variant here so the build hook
  # does not reintroduce the default Qt build and its dependencies.
  qmake = libsForQt5.qmake.override { inherit qtbase; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fulcrum";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "cculianu";
    repo = "Fulcrum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YfID94tmNTg+BqEEAmB3if+gNCNrU3NamTOMVfjXAMY=";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
  ];

  buildInputs = [
    python3
    qtbase
    rocksdb_9_10
    zeromq
  ];

  # This command-line server does not need a wrapper to locate Qt GUI plugins.
  dontWrapQtApps = true;

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
