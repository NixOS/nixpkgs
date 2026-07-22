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
  version = "0.9.0";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "ckruse";
    repo = "Gitte";
    tag = finalAttrs.version;
    hash = "sha256-k10Rqpf9fhcG+PU6WGr7Q2nVwZb0tLp2B2r3BNeicoI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-eK8o/psq0eHwUlbfD0I/TwIqoA40Ay0eJ9CtZypZCi4=";
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
