{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  dbus,
  gdk-pixbuf,
  glib,
  gtk3,
  cairo,
  atk,
  pango,
  harfbuzz,
  gtk-layer-shell,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rumno";
  version = "0.1.4";

  src = fetchFromGitLab {
    owner = "ivanmalison";
    repo = "rumno";
    tag = "v${finalAttrs.version}";
    hash = "sha256-81apQdjeVud7/2w5ZaacvqMG+MGGhk3XhhRiRfD5VFk=";
  };

  cargoHash = "sha256-7OI5t2sX4xNljcIMzynpqncPvhn9Pu65G0/JIzxGnEQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    gdk-pixbuf
    glib
    gtk3
    cairo
    atk
    pango
    harfbuzz
    gtk-layer-shell
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Visual pop-up notification manager";
    homepage = "https://gitlab.com/ivanmalison/rumno";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ imalison ];
    mainProgram = "rumno";
    platforms = lib.platforms.linux;
  };
})
