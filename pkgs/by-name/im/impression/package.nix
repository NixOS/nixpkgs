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
  version = "3.3.0";

  src = fetchFromGitLab {
    owner = "adhami3310";
    repo = "Impression";
    rev = "v${finalAttrs.version}";
    hash = "sha256-F2ZyATDKnUgEOAI++54fR6coJOr9rtyGm5TzsKzkDmg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-H4x7D25UzDdAEad7QEsZZGLXhfiUupm3mTrNho+ShFo=";
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
    maintainers = with lib.maintainers; [ dotlambda ] ++ lib.teams.gnome-circle.members;
    platforms = lib.platforms.linux;
  };
})
