{
  lib,
  stdenv,
  fetchFromGitHub,

  appstream,
  appstream-glib,
  desktop-file-utils,
  gettext,
  glib,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,

  blueprint-compiler,
  glycin-loaders,
  gtk4,
  json-glib,
  libadwaita,
  libbacktrace,
  libglycin-gtk4,
  libsoup_3,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-extension-manager";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mjakeman";
    repo = "extension-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-af0Ml6JULE0+jBSeB7CSrv+8/1XasSv+fbUYqDoe4/4=";
  };

  nativeBuildInputs = [
    appstream
    appstream-glib
    desktop-file-utils
    gettext
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    blueprint-compiler
    glycin-loaders
    gtk4
    json-glib
    libadwaita
    libbacktrace
    libglycin-gtk4
    libsoup_3
    libxml2
  ];

  mesonFlags = [
    (lib.mesonOption "package" "Nix")
    (lib.mesonOption "distributor" "nixpkgs")
  ];

  meta = {
    description = "Desktop app for managing GNOME shell extensions";
    homepage = "https://github.com/mjakeman/extension-manager";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "extension-manager";
    maintainers = [ ];
  };
})
