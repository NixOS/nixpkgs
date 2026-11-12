{
  cargo,
  desktop-file-utils,
  fetchFromGitLab,
  lib,
  libadwaita,
  libxml2,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  rustc,
  rustPlatform,
  stdenv,
  wrapGAppsHook4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "app-icon-preview";
  version = "3.5.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "design";
    repo = "app-icon-preview";
    tag = finalAttrs.version;
    hash = "sha256-sfQFmQ27JUu92ArCi1dTnD3sWoUl/0tJguMvR1BoK/Q=";
    forceFetchGit = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-WGzXjIgZBwuBbSWK+EWDMW2kfqeoYHMsP4TXglR2Sc4=";
  };

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    libxml2
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for designing applications icons";
    homepage = "https://gitlab.gnome.org/World/design/app-icon-preview";
    license = lib.licenses.gpl3Only;
    mainProgram = "app-icon-preview";
    maintainers = with lib.maintainers; [ hythera ];
    platforms = lib.platforms.linux;
  };
})
