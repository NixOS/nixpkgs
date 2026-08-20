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
  libcdio,
  openssl,
  pango,
  wimlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "impression";
  version = "3.8.0";

  src = fetchFromGitLab {
    owner = "adhami3310";
    repo = "Impression";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kUes+hNtoi6jvZFDon2pFUPsLq7wOJ2SDrPBGzg3AIo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-PL+PJ5Diy9WvAuBJQQNp8bvjPK3Uvd0Um/B6lZHypXw=";
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
    libcdio
    openssl
    pango
    wimlib
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Straight-forward and modern application to create bootable drives";
    homepage = "https://gitlab.com/adhami3310/Impression";
    changelog = "https://gitlab.com/adhami3310/Impression/-/releases/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "impression";
    maintainers = with lib.maintainers; [ dotlambda ];
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
  };
})
