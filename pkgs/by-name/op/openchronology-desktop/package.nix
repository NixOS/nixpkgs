{
  lib,
  rustPlatform,
  openchronology-server,
  cargo-tauri,
  nodejs_24,
  npmHooks,
  pkg-config,
  cmake,
  wrapGAppsHook3,
  webkitgtk_4_1,
  gtk3,
  libsoup_3,
  glib-networking,
  openssl,
  sqlite,
  gmp,
}:

rustPlatform.buildRustPackage {
  pname = "openchronology-desktop";
  # The same release as the server: one source and one npm lockfile.
  inherit (openchronology-server) version src npmDeps;

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";
  cargoHash = "sha256-HfwRHBDrBKTKSeAMgzjufwWxhYSdXmn0d707JvE05KA=";

  # Install scripts would download what the lockfile already provides.
  npmFlags = [ "--ignore-scripts" ];
  # npm adds the vendored rational-ordered-map tarball (a file: dependency) to its cache.
  makeCacheWritable = true;
  # The native store's build script runs CMake itself.
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs_24
    npmHooks.npmConfigHook
    pkg-config
    cmake
    wrapGAppsHook3
  ];
  buildInputs = [
    webkitgtk_4_1
    gtk3
    libsoup_3
    glib-networking
    openssl
    sqlite
    gmp
  ];

  # The app's tests need a display; upstream's CI runs them.
  doCheck = false;

  meta = {
    description = "Desktop editor for OpenChronology timelines, with exact times";
    homepage = "https://github.com/openchronology/timeline-app";
    changelog = "https://github.com/openchronology/timeline-app/releases/tag/v${openchronology-server.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ athanclark ];
    mainProgram = "openchronology-desktop";
    platforms = lib.platforms.linux;
  };
}
