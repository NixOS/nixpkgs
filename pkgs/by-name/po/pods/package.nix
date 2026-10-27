{
  lib,
  stdenv,
  fetchFromGitHub,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  glib,
  gtk4,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  gtksourceview5,
  libadwaita,
  libpanel,
  vte-gtk4,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pods";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "marhkb";
    repo = "pods";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Euo3cbZYGdhvbYUG5ow9ajGv5ylqRG03/TdVc0VV4gg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ejk++8riGsr1exL7jrdOo3g3EPidG0hrz8zoy0tIT8Q=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    glib
    gtk4
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtksourceview5
    libadwaita
    libpanel
    vte-gtk4
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Podman desktop application";
    homepage = "https://github.com/marhkb/pods";
    changelog = "https://github.com/marhkb/pods/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ iamanaws ];
    platforms = lib.platforms.linux;
    mainProgram = "pods";
  };
})
