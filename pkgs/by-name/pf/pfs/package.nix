{
  lib,
  stdenv,
  fetchFromGitLab,
  cargo,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  cairo,
  desktop-file-utils, # for update-desktop-database
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  pango,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pfs";
  version = "0.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "guidog";
    repo = "pfs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M4SNtGQJIduK87tNsiX7GZeXa5BEfRSxo1cNvXKeVZ0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    src = finalAttrs.src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-PBM6Gvpp8u70Sqnur6i5+WtG+hiluepgbyAnnxmANE4=";
  };

  nativeBuildInputs = [
    cargo
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    desktop-file-utils
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    pango
  ];

  meta = {
    description = "File chooser widget in Rust using gtk-rs and libadwaita (PhoshFileSelector)";
    homepage = "https://gitlab.gnome.org/guidog/pfs";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "pfs-demo";
    platforms = lib.platforms.linux;
  };
})
