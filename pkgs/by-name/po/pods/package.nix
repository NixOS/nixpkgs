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
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "marhkb";
    repo = "pods";
    tag = "v${finalAttrs.version}";
    hash = "sha256-50NOkLffLbs5/qug6xzoSWSMZ3+/Lau9sTPi9za4+LA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-JbYJQdli3OAxnbGApVe5+KAAcGePTTH59fdXdFx0+hA=";
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
