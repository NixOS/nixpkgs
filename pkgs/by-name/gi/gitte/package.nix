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
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "ckruse";
    repo = "Gitte";
    tag = finalAttrs.version;
    hash = "sha256-niVICk2RtDFA0/NK4cP+CU4uII/LcYjB+ZV60IHmr40=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-hJlO4GXPg6LWBCSKTQAwAawgWwN+OckvV2t9svTsaj4=";
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
    license = with lib.licenses; [ agpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ckruse
      orzklv
    ];
  };
})
