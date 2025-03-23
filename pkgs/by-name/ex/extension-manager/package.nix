{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  gettext,
  gtk4,
  json-glib,
  libadwaita,
  libbacktrace,
  libsoup_3,
  libxml2,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "extension-manager";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "mjakeman";
    repo = "extension-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0AK7wU04gQCS/3FvoAwAEmaP/jC23EduOSRncLjt4l8=";
  };

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gettext
    gtk4
    json-glib
    libadwaita
    libbacktrace
    libsoup_3
    libxml2
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility for browsing and installing GNOME Shell Extensions";
    homepage = "https://github.com/mjakeman/extension-manager";
    changelog = "https://github.com/mjakeman/extension-manager/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ arthsmn ];
    mainProgram = "extension-manager";
    platforms = lib.platforms.linux;
  };
})
