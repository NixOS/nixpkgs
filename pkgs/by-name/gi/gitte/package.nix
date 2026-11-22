{
  lib,
  stdenv,
  fetchFromCodeberg,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  cargo,
  rustc,
  wrapGAppsHook4,
  desktop-file-utils,
  appstream,
  gettext,
  glib,
  gtk4,
  libadwaita,
  openssl,
  libgit2,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gitte";
  version = "0.11.1";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "ckruse";
    repo = "Gitte";
    tag = finalAttrs.version;
    hash = "sha256-3f8tGoMmqLxS5K3/yrHq025GyMZGN0e6bN3JtC5OGy8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-NDqaoK0Yudd0+yc3T3qm650yX4mkL4emqIzd1yYbltY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsHook4
    desktop-file-utils
    appstream
    gettext
    glib
  ];

  buildInputs = [
    gtk4
    libadwaita
    openssl
    libgit2
    zlib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://codeberg.org/ckruse/Gitte";
    mainProgram = "gitte";
    description = "GTK4/libadwaita Git client";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ckruse
      orzklv
    ];
  };
})
