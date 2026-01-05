{
  lib,
  stdenv,
  fetchFromGitHub,
  vala,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  blueprint-compiler,
  desktop-file-utils,
  appstream,
  gtk4,
  libadwaita,
  webkitgtk_6_0,
  json-glib,
  libgee,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "karere";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "tobagin";
    repo = "karere";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QpKKUP/Lp0nWI+h67Uc2f+4G3LG593hLB7b7IMinThI=";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    blueprint-compiler
    desktop-file-utils
    appstream
  ];

  buildInputs = [
    gtk4
    libadwaita
    webkitgtk_6_0
    json-glib
    libgee
  ];

  meta = {
    description = "Gtk4 Whatsapp client";
    homepage = "https://github.com/tobagin/karere";
    changelog = "https://github.com/tobagin/karere/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ marcel ];
    mainProgram = "karere";
  };
})
