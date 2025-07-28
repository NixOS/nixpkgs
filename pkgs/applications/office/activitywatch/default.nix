{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  makeWrapper,
  pkg-config,
  perl,
  openssl,
  rust-jemalloc-sys,
  python3,
  python3Packages,
  wrapQtAppsHook,
  qtbase,
  qtsvg,
  xdg-utils,
  replaceVars,
  buildNpmPackage,
}:

let
  version = "0.13.2";
  sources = fetchFromGitHub {
    owner = "ActivityWatch";
    repo = "activitywatch";
    rev = "v${version}";
    sha256 = "sha256-Z3WAg3b1zN0nS00u0zIose55JXRzQ7X7qy39XMY7Snk=";
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
      xlib
      pynput
    ];

    pythonRelaxDeps = [
      "python-xlib"
    ];

    pythonImportsCheck = [ "aw_watcher_afk" ];

    meta = with lib; {
      description = "Watches keyboard and mouse activity to determine if you are AFK or not (for use with ActivityWatch)";
      homepage = "https://github.com/ActivityWatch/aw-watcher-afk";
      maintainers = with maintainers; [ huantian ];
      mainProgram = "aw-watcher-afk";
      license = licenses.mpl20;
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
      xlib
    ];

    pythonRelaxDeps = [
      "python-xlib"
    ];

    pythonImportsCheck = [ "aw_watcher_window" ];

    meta = with lib; {
      description = "Cross-platform window watcher (for use with ActivityWatch)";
      homepage = "https://github.com/ActivityWatch/aw-watcher-window";
      maintainers = with maintainers; [ huantian ];
      mainProgram = "aw-watcher-window";
      license = licenses.mpl20;
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
      qtbase
      qtsvg # Rendering icons in the trayicon menu
      pyqt6
      click
    ];

    nativeBuildInputs = [
      wrapQtAppsHook
    ];

    # Prevent double wrapping
    dontWrapQtApps = true;

    makeWrapperArgs = [
      "--suffix PATH : ${lib.makeBinPath [ xdg-utils ]}"
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

    meta = with lib; {
      description = "Tray icon that manages ActivityWatch processes, built with Qt";
      homepage = "https://github.com/ActivityWatch/aw-qt";
      maintainers = with maintainers; [ huantian ];
      mainProgram = "aw-qt";
      license = licenses.mpl20;
      badPlatforms = lib.platforms.darwin; # requires pyobjc-framework
    };
  };

  aw-notify = python3Packages.buildPythonApplication {
    pname = "aw-notify";
    inherit version;

    src = "${sources}/aw-notify";

    pyproject = true;
    build-system = [ python3Packages.poetry-core ];

    dependencies = with python3Packages; [
      aw-client
      desktop-notifier
    ];

    pythonRelaxDeps = [
      "desktop-notifier"
    ];

    pythonImportsCheck = [ "aw_notify" ];

    meta = with lib; {
      description = "Desktop notification service for ActivityWatch";
      homepage = "https://github.com/ActivityWatch/aw-notify";
      maintainers = with maintainers; [ huantian ];
      mainProgram = "aw-notify";
      license = licenses.mpl20;
    };
  };

  aw-server-rust = rustPlatform.buildRustPackage {
    pname = "aw-server-rust";
    inherit version;

    src = "${sources}/aw-server-rust";

    cargoHash = "sha256-E89E/LWBPHtb6vX94swodmE+UrWMrzQnm8AO5GeyuoA=";

    patches = [
      # Override version string with hardcoded value as it may be outdated upstream.
      (replaceVars ./override-version.patch {
        version = sources.rev;
      })
    ];

    nativeBuildInputs = [
      makeWrapper
      pkg-config
      perl
    ];

    buildInputs = [
      openssl
      rust-jemalloc-sys
    ];

    env.AW_WEBUI_DIR = aw-webui;

    preCheck = ''
      # Fake home folder for tests that use ~/.cache and ~/.local/share
      export HOME="$TMPDIR"
    '';

    meta = with lib; {
      description = "High-performance implementation of the ActivityWatch server, written in Rust";
      homepage = "https://github.com/ActivityWatch/aw-server-rust";
      maintainers = with maintainers; [ huantian ];
      mainProgram = "aw-server";
      platforms = platforms.linux;
      license = licenses.mpl20;
    };
  };

  aw-webui = buildNpmPackage {
    pname = "aw-webui";
    inherit version;

    src = "${sources}/aw-server-rust/aw-webui";

    npmDepsHash = "sha256-fPk7UpKuO3nEN1w+cf9DIZIG1+XRUk6PJfVmtpC30XE=";

    makeCacheWritable = true;

    patches = [
      # Hardcode version to avoid the need to have the Git repo available at build time.
      (replaceVars ./commit-hash.patch {
        commit_hash = sources.rev;
      })
    ];

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

    meta = with lib; {
      description = "Web-based UI for ActivityWatch, built with Vue.js";
      homepage = "https://github.com/ActivityWatch/aw-webui/";
      maintainers = with maintainers; [ huantian ];
      license = licenses.mpl20;
    };
  };
}
