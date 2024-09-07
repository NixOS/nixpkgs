{
  appstream-glib,
  cairo,
  cargo,
  desktop-file-utils,
  fetchFromGitLab,
  gdb,
  gdk-pixbuf,
  git,
  glib,
  gtk4,
  gtksourceview5,
  lib,
  libadwaita,
  libgit2,
  libusb1,
  meson,
  ninja,
  nix-update-script,
  openssl,
  openxr-loader,
  pango,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  vte-gtk4,
  wrapGAppsHook4,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "envision-unwrapped";
  version = "0-unstable-2024-09-06";

  src = fetchFromGitLab {
    owner = "gabmus";
    repo = "envision";
    rev = "849f47a8533bc3fc673afbdd9b32acac3ff26f7d";
    hash = "sha256-t1+4MXD1s4NW38r3Ht+1OmCAY44MqEPijXdUVKy0rY4=";
  };

  strictDeps = true;

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libmonado-rs-0.1.0" = "sha256-xztevBUaYBm5G3A0ZTb+3GV3g1IAU3SzfSS5BBqfp1Y=";
      "openxr-0.18.0" = "sha256-ktkbhmExstkNJDYM/HYOwAwv3acex7P9SP0KMAOKhQk=";
    };
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    cargo
    git
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    gtksourceview5
    libadwaita
    libgit2
    libusb1
    openssl
    openxr-loader
    pango
    vte-gtk4
    zlib
  ];

  postInstall = ''
    wrapProgram $out/bin/envision \
      --prefix PATH : "${lib.makeBinPath [ gdb ]}"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  meta = {
    description = "UI for building, configuring and running Monado, the open source OpenXR runtime";
    homepage = "https://gitlab.com/gabmus/envision";
    license = lib.licenses.agpl3Only;
    mainProgram = "envision";
    maintainers = with lib.maintainers; [
      pandapip1
      Scrumplex
    ];
    platforms = lib.platforms.linux;
  };
})
