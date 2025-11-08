{
  alsa-lib,
  atk,
  cairo,
  dbus,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  gtk3,
  lib,
  libclang,
  makeDesktopItem,
  nix-update-script,
  pango,
  pkg-config,
  rustPlatform,
  stdenv,
}:

let
  desktopItem = makeDesktopItem {
    categories = [
      "Audio"
      "AudioVideo"
    ];
    comment = "Spotify client with native GUI written in Rust, without Electron";
    desktopName = "Psst";
    exec = "psst-gui %U";
    icon = "psst";
    name = "Psst";
    startupWMClass = "psst-gui";
  };
in
rustPlatform.buildRustPackage {
  pname = "psst";
  version = "0-unstable-2025-04-20";

  src = fetchFromGitHub {
    owner = "jpochyla";
    repo = "psst";
    rev = "86169f8b05c1b3502261cfe1fae9af2487b8f1bb";
    hash = "sha256-BkGoaYflCTiElTj47r2j/ngUrZ9wIe0q4pl+zhoattA=";
  };

  cargoHash = "sha256-gt2EDrZ+XXig5JUsmQksSLaFd7UArnttOT4UiTVASXw=";

  # specify the subdirectory of the binary crate to build from the workspace
  buildAndTestSubdir = "psst-gui";

  env = {
    LIBCLANG_PATH = "${lib.getLib libclang}/lib";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    pango
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    dbus
  ];

  patches = [
    # Use a fixed build time, hard-code upstream URL instead of trying to read `.git`
    ./make-build-reproducible.patch
  ];

  postInstall = ''
    install -Dm644 psst-gui/assets/logo_512.png -t $out/share/icons/hicolor/512x512/apps/psst.png
    install -Dm644 ${desktopItem}/share/applications/* -t $out/share/applications
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Spotify client with native GUI written in Rust, without Electron";
    homepage = "https://github.com/jpochyla/psst";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      vbrandl
      peterhoeg
    ];
    mainProgram = "psst-gui";
  };
}
