{
  lib,
  rustPlatform,
  fetchFromGitHub,
  glib-networking,
  pkg-config,
  wrapGAppsHook4,
  nix-update-script,
  libxkbcommon,
  wayland,
  glib,
  gobject-introspection,
  gtk4,
  libadwaita,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nmrs";
  version = "0.1.1-beta";

  src = fetchFromGitHub {
    owner = "cachebag";
    repo = "nmrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ir5GaPVWEbL0/ABVcX2OFibBoNf6Yfj+R6VqtxZ8Igo=";
  };

  cargoHash = "sha256-bGfDO3kLwecOnXMr+L1o4nUytx8hQGqdNOmOZHnG3/Y=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib-networking
    libxkbcommon
    wayland
    glib
    gobject-introspection
    gtk4
    libadwaita
  ];

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland-native frontend for NetworkManager";
    homepage = "https://github.com/cachebag/nmrs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cachebag
      joncorv
    ];
    mainProgram = "nmrs-ui";
    platforms = lib.platforms.linux;
  };
})
