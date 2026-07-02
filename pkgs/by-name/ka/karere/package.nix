{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  meson,
  ninja,
  pkg-config,
  cargo,
  rustc,
  wrapGAppsHook4,
  blueprint-compiler,
  desktop-file-utils,
  appstream,
  gtk4,
  libadwaita,
  webkitgtk_6_0,
  glib-networking,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "karere";
  version = "2.5.5";

  src = fetchFromGitHub {
    owner = "tobagin";
    repo = "karere";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cR4+nZvz7ELy9/POX9yZiryVcCcpC63mFhZ6kvR33i8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-h51B8iGiMWHbHogJSAKdm27QDBPzlrkCxlYOj9T4SuI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cargo
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
    blueprint-compiler
    desktop-file-utils
    appstream
  ];

  buildInputs = [
    gtk4
    libadwaita
    webkitgtk_6_0
    glib-networking
  ];

  meta = {
    description = "Gtk4 Whatsapp client";
    homepage = "https://github.com/tobagin/karere";
    changelog = "https://github.com/tobagin/karere/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      marcel
      aleksana
    ];
    mainProgram = "karere";
  };
})
