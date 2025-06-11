{
  lib,
  cargo,
  desktop-file-utils,
  fetchFromGitLab,
  gtk4,
  gtksourceview5,
  libadwaita,
  libspelling,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "buffer";
  version = "0.10.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "cheywood";
    repo = "buffer";
    tag = finalAttrs.version;
    hash = "sha256-81riamRKzV4wXVTXkp1ngO/5mG7leRJMw/r2DDHl8LU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src pname version;
    hash = "sha256-fwXeXaoC/Uh9eMEkRjhpAouxOrlRWX2n2r4pgIe83S0=";
  };

  nativeBuildInputs = [
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
    gtk4
    gtksourceview5
    libadwaita
    libspelling
  ];

  meta = {
    description = "Minimal editing space for all those things that don't need keeping";
    homepage = "https://gitlab.gnome.org/cheywood/buffer";
    license = lib.licenses.gpl3Plus;
    mainProgram = "buffer";
    maintainers = with lib.maintainers; [ michaelgrahamevans ];
    platforms = lib.platforms.linux;
  };
})
