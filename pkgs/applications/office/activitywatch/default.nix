{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  pkg-config,
  tzdata,
  perl,
  openssl,
  rust-jemalloc-sys,
  sqlite,
  python3,
  python3Packages,
  qt6,
  xdg-utils,
  nodejs_22,
  buildNpmPackage,
}:

let
  version = "0.14.2";
  sources = fetchFromGitHub {
    owner = "ActivityWatch";
    repo = "activitywatch";
    rev = "v${version}";
    hash = "sha256-lAE9pTC9tGB0mIuYOPcsWyv66aOov/5uA8QblvmlrOw=";
    fetchSubmodules = true;
  };
in
rec {
  aw-watcher-afk = python3Packages.buildPythonApplication {
    pname = "aw-watcher-afk";
    inherit version;

    src = "${sources}/aw-watcher-afk";

    pyproject = true;
    build-system = [ python3Packages.poetry-core ];

    dependencies = with python3Packages; [
      aw-client
      python-xlib
      pynput
    ];

    pythonRelaxDeps = [
      "python-xlib"
    ];

    pythonImportsCheck = [ "aw_watcher_afk" ];

    meta = {
      description = "Watches keyboard and mouse activity to determine if you are AFK or not (for use with ActivityWatch)";
      homepage = "https://github.com/ActivityWatch/aw-watcher-afk";
      maintainers = with lib.maintainers; [ huantian ];
      mainProgram = "aw-watcher-afk";
      license = lib.licenses.mpl20;
    };
  };

  aw-watcher-window = python3Packages.buildPythonApplication {
    pname = "aw-watcher-window";
    inherit version;

    src = "${sources}/aw-watcher-window";

    pyproject = true;
    build-system = [ python3Packages.poetry-core ];

    dependencies = with python3Packages; [
      aw-client
      python-xlib
    ];

    pythonRelaxDeps = [
      "python-xlib"
    ];

    pythonImportsCheck = [ "aw_watcher_window" ];

    meta = {
      description = "Cross-platform window watcher (for use with ActivityWatch)";
      homepage = "https://github.com/ActivityWatch/aw-watcher-window";
      maintainers = with lib.maintainers; [ huantian ];
      mainProgram = "aw-watcher-window";
      license = lib.licenses.mpl20;
      badPlatforms = lib.platforms.darwin; # requires pyobjc-framework
    };
  };

  aw-qt = python3Packages.buildPythonApplication {
    pname = "aw-qt";
    inherit version;

    src = "${sources}/aw-qt";

    pyproject = true;
    build-system = [
      python3Packages.poetry-core
      python3Packages.setuptools
    ];

    dependencies = with python3Packages; [
      aw-core
      pyqt6
      click
    ];

    buildInputs = [
      qt6.qtbase
      qt6.qtsvg # Rendering icons in the trayicon menu
    ];

    nativeBuildInputs = [
      qt6.wrapQtAppsHook
    ];

    # Prevent double wrapping
    dontWrapQtApps = true;

    makeWrapperArgs = [
      "--suffix"
      "PATH"
      ":"
      (lib.makeBinPath [ xdg-utils ])
    ];

    postInstall = ''
      install -D resources/aw-qt.desktop $out/share/applications/aw-qt.desktop

      # For the actual tray icon, see
      # https://github.com/ActivityWatch/aw-qt/blob/8ec5db941ede0923bfe26631acf241a4a5353108/aw_qt/trayicon.py#L211-L218
      install -D media/logo/logo.png $out/${python3.sitePackages}/media/logo/logo.png

      # For .desktop file and your desktop environment
      install -D media/logo/logo.svg $out/share/icons/hicolor/scalable/apps/activitywatch.svg
      install -D media/logo/logo.png $out/share/icons/hicolor/512x512/apps/activitywatch.png
      install -D media/logo/logo-128.png $out/share/icons/hicolor/128x128/apps/activitywatch.png
    '';

    preFixup = ''
      makeWrapperArgs+=(
        "''${qtWrapperArgs[@]}"
      )
    '';

    pythonImportsCheck = [ "aw_qt" ];

    meta = {
      description = "Tray icon that manages ActivityWatch processes, built with Qt";
      homepage = "https://github.com/ActivityWatch/aw-qt";
      maintainers = with lib.maintainers; [ huantian ];
      mainProgram = "aw-qt";
      license = lib.licenses.mpl20;
      badPlatforms = lib.platforms.darwin; # requires pyobjc-framework
    };
  };

  aw-notify = rustPlatform.buildRustPackage {
    pname = "aw-notify";
    inherit version;
    __structuredAttrs = true;

    src = "${sources}/aw-notify";

    cargoHash = "sha256-Mep7ppAQ/nCwHKSsokjY7HKFwDtakmqK8oFoM6HtTT0=";

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      openssl
    ];

    # Scheduling tests need a time zone database
    nativeCheckInputs = [ tzdata ];

    meta = {
      description = "Desktop notification service for ActivityWatch";
      homepage = "https://github.com/ActivityWatch/aw-notify";
      maintainers = with lib.maintainers; [ huantian ];
      mainProgram = "aw-notify";
      license = lib.licenses.mpl20;
    };
  };

  aw-server-rust = rustPlatform.buildRustPackage {
    pname = "aw-server-rust";
    inherit version;

    src = "${sources}/aw-server-rust";

    cargoHash = "sha256-8qbH7jlduLQhfrGMbpvZYs/BMojzaGOIa3+Prv0tlO0=";

    # Override version string with hardcoded value as it may be outdated upstream.
    postPatch = ''
      substituteInPlace aw-server/src/version.rs \
        --replace-fail 'option_env!("CARGO_PKG_VERSION")' 'Some("${version}")'
    '';

    nativeBuildInputs = [
      makeWrapper
      pkg-config
      perl
    ];

    buildInputs = [
      openssl
      rust-jemalloc-sys
      sqlite
    ];

    # Build only aw-server package to bypass broken aw-sync features
    cargoTestFlags = [ "--package aw-server" ];
    cargoBuildFlags = [ "--package aw-server" ];

    env.AW_WEBUI_DIR = aw-webui;

    # Fake home folder for tests that use ~/.cache and ~/.local/share
    preCheck = ''
      export HOME="$TMPDIR"
    '';

    meta = {
      description = "High-performance implementation of the ActivityWatch server, written in Rust";
      homepage = "https://github.com/ActivityWatch/aw-server-rust";
      maintainers = with lib.maintainers; [ huantian ];
      mainProgram = "aw-server";
      platforms = lib.platforms.linux;
      license = lib.licenses.mpl20;
    };
  };

  aw-webui = buildNpmPackage {
    pname = "aw-webui";
    inherit version;

    src = "${sources}/aw-server-rust/aw-webui";

    nodejs = nodejs_22;
    npmDepsHash = "sha256-XJuIBFNdm8he7OF3X6Szxo74/usfIcwtrLPPY3HYnlU=";

    makeCacheWritable = true;
    npmFlags = [ "--legacy-peer-deps" ];

    # The fetched source has no .git, so hardcode the `commit hash` shown in the developer settings
    postPatch = ''
      substituteInPlace vue.config.js \
        --replace-fail "child_process.execSync('git rev-parse --short HEAD').toString().trim()" '"${sources.rev}"'
    '';

    installPhase = ''
      runHook preInstall
      mv dist $out
      mv media/logo/logo.{png,svg} $out
      runHook postInstall
    '';

    doCheck = true;

    checkPhase = ''
      runHook preCheck
      npm test
      runHook postCheck
    '';

    meta = {
      description = "Web-based UI for ActivityWatch, built with Vue.js";
      homepage = "https://github.com/ActivityWatch/aw-webui/";
      maintainers = with lib.maintainers; [ huantian ];
      license = lib.licenses.mpl20;
    };
  };
}
