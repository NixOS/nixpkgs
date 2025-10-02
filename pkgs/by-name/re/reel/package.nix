{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  desktop-file-utils,
  wrapGAppsHook4,
  gtk4,
  libadwaita,
  adwaita-icon-theme,
  hicolor-icon-theme,
  libepoxy,
  gst_all_1,
  glib,
  cairo,
  pango,
  gdk-pixbuf,
  graphene,
  sqlite,
  openssl,
  curl,
  glib-networking,
  libsecret,
  dbus,
  gettext,
  librsvg,
  mold,
  mpv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reel";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "arsfeld";
    repo = "reel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o4DgocqWBEjfOZaTOyKAFjSvyF00VQ3EBhODPfJE75c=";
  };

  cargoHash = "sha256-zHZ+BsyOdMPvoJJRd+S4f6lJ2WR8/whrbcgI5Cw2VQI=";

  nativeBuildInputs = [
    desktop-file-utils
    mold
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    adwaita-icon-theme
    cairo
    curl
    dbus
    dbus.dev
    gdk-pixbuf
    gettext
    glib
    glib-networking
    graphene
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-rs
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    gtk4
    hicolor-icon-theme
    libadwaita
    libepoxy
    librsvg
    libsecret
    mpv
    openssl
    pango
    sqlite
  ];

  postInstall = ''
    wrapProgram $out/bin/reel \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath ( finalAttrs.buildInputs )
      }
  '';

  # Running tests fail:
  #   Running unittests src/lib.rs (target/x86_64-unknown-linux-gnu/release/deps/reel-4f2ffc60f7acb19a)
  #   /build/source/target/x86_64-unknown-linux-gnu/release/deps/reel-4f2ffc60f7acb19a: error while loading shared libraries: libdbus-1.so.3: cannot open shared object file: No such file or directory
  #   error: test failed, to rerun pass `--lib`
  #   Caused by:
  #   process didn't exit successfully: `/build/source/target/x86_64-unknown-linux-gnu/release/deps/reel-4f2ffc60f7acb19a` (exit status: 127)
  #   note: test exited abnormally; to see the full output pass --nocapture to the harness.
  doCheck = false;

  meta = {
    description = "Reel - A modern, native media player for the GNOME desktop";
    homepage = "https://github.com/arsfeld/reel";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.onny ];
    platforms = lib.platforms.linux;
  };
})
