{ lib
, fetchFromGitHub
, fetchpatch
, rustPlatform
, makeWrapper
, pkg-config
, perl
, openssl
, rust-jemalloc-sys
, python3
, wrapQtAppsHook
, qtbase
, qtsvg
, xdg-utils
, substituteAll
, buildNpmPackage
}:

let
  version = "0.12.2";
  sources = fetchFromGitHub {
    owner = "ActivityWatch";
    repo = "activitywatch";
    rev = "v${version}";
    sha256 = "sha256-IvRXfxTOSgBVlxy4SVij+POr7KgvXTEjGN3lSozhHkY=";
    fetchSubmodules = true;
  };
in
rec {
  aw-watcher-afk = python3.pkgs.buildPythonApplication {
    pname = "aw-watcher-afk";
    inherit version;

    format = "pyproject";

    src = "${sources}/aw-watcher-afk";

    nativeBuildInputs = [
      python3.pkgs.poetry-core
    ];

    propagatedBuildInputs = with python3.pkgs; [
      aw-client
      xlib
      pynput
    ];

    pythonImportsCheck = [ "aw_watcher_afk" ];

    meta = with lib; {
      description = "Watches keyboard and mouse activity to determine if you are AFK or not (for use with ActivityWatch)";
      homepage = "https://github.com/ActivityWatch/aw-watcher-afk";
      maintainers = with maintainers; [ huantian ];
      license = licenses.mpl20;
    };
  };

  aw-watcher-window = python3.pkgs.buildPythonApplication {
    pname = "aw-watcher-window";
    inherit version;

    format = "pyproject";

    src = "${sources}/aw-watcher-window";

    nativeBuildInputs = [
      python3.pkgs.poetry-core
    ];

    propagatedBuildInputs = with python3.pkgs; [
      aw-client
      xlib
    ];

    pythonImportsCheck = [ "aw_watcher_window" ];

    meta = with lib; {
      description = "Cross-platform window watcher (for use with ActivityWatch)";
      homepage = "https://github.com/ActivityWatch/aw-watcher-window";
      maintainers = with maintainers; [ huantian ];
      license = licenses.mpl20;
    };
  };

  aw-qt = python3.pkgs.buildPythonApplication {
    pname = "aw-qt";
    inherit version;

    format = "pyproject";

    src = "${sources}/aw-qt";

    nativeBuildInputs = [
      python3.pkgs.poetry-core
      wrapQtAppsHook
    ];

    propagatedBuildInputs = with python3.pkgs; [
      aw-core
      qtbase
      qtsvg # Rendering icons in the trayicon menu
      pyqt6
      click
    ];

    # Prevent double wrapping
    dontWrapQtApps = true;

    makeWrapperArgs = [
      "--suffix PATH : ${lib.makeBinPath [ xdg-utils ]}"
    ];

    postPatch = ''
      sed -E 's#PyQt6 = "6.3.1"#PyQt6 = "^6.4.0"#g' -i pyproject.toml
    '';

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
      license = licenses.mpl20;
    };
  };

  aw-server-rust = rustPlatform.buildRustPackage {
    pname = "aw-server-rust";
    inherit version;

    src = "${sources}/aw-server-rust";

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "rocket_cors-0.6.0-alpha1" = "sha256-GuMekgnsyuOg6lMiVvi4TwMba4sAFJ/zkgrdzSeBrv0=";
      };
    };

    # Bypass rust nightly features not being available on rust stable
    RUSTC_BOOTSTRAP = 1;

    patches = [
      # Override version string with hardcoded value as it may be outdated upstream.
      (substituteAll {
        src = ./override-version.patch;
        version = sources.rev;
      })

      # Can be removed with release 0.12.3
      (fetchpatch {
        name = "remove-unused-unstable-features.patch";
        url = "https://github.com/ActivityWatch/aw-server-rust/commit/e1cd761d2f0a9309eb851b59732c2567a7ae2d3a.patch";
        hash = "sha256-wP+3XZDkr148XY5b8RV3obuLczAFBE3FhaYPqnmmGcU=";
        includes = [ "aw-server/src/lib.rs" ];
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

    postFixup = ''
      wrapProgram "$out/bin/aw-server" \
        --prefix XDG_DATA_DIRS : "$out/share"

      mkdir -p "$out/share/aw-server"
      ln -s "${aw-webui}" "$out/share/aw-server/static"
    '';

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

    npmDepsHash = "sha256-yds2P2PKfTB6yUGnc+P73InV5+MZP9kmz2ZS4CRqlmA=";

    patches = [
      # Hardcode version to avoid the need to have the Git repo available at build time.
      (substituteAll {
        src = ./commit-hash.patch;
        commit_hash = sources.rev;
      })
    ];

    installPhase = ''
      runHook preInstall
      mv dist $out
      cp media/logo/logo.{png,svg} $out/static/
      runHook postInstall
    '';

    doCheck = true;
    checkPhase = ''
      runHook preCheck
      npm test
      runHook postCheck
    '';

    meta = with lib; {
      description = "A web-based UI for ActivityWatch, built with Vue.js";
      homepage = "https://github.com/ActivityWatch/aw-webui/";
      maintainers = with maintainers; [ huantian ];
      license = licenses.mpl20;
    };
  };
}
