{
  lib,
  stdenv,
  fetchFromGitLab,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  cairo,
  dbus,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  openssl,
  pango,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "impression";
  version = "3.1.0";

  src = fetchFromGitLab {
    owner = "adhami3310";
    repo = "Impression";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5hBpe8D3DVXP6Hq5L4OUL9rCml0MoLdK7uZzbIIkNh0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-lbpbggf4DEjpXJ52aM7qNd01XCEY3xj8dKGMfCZ9i3A=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    openssl
    pango
  ];

  meta = {
    description = "Straight-forward and modern application to create bootable drives";
    homepage = "https://gitlab.com/adhami3310/Impression";
    license = lib.licenses.gpl3Only;
    mainProgram = "impression";
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
})
