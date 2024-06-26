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
  version = "3.2.0";

  src = fetchFromGitLab {
    owner = "adhami3310";
    repo = "Impression";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cNkc/z0hVNYdyuCw0nHKEQKdQVeRouk/K7gIp0xpjt4=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-IcmJAD/55dOdN04N/wd6gZ9DO/UdUire1eXSuNMxu9M=";
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
