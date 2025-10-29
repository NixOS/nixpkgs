{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  glib,
  blueprint-compiler,
  gobject-introspection,
  gtk4,
  desktop-file-utils,
  gettext,
  wrapGAppsHook4,
  libadwaita,
  gjs,
  gnome-autoar,
  libsoup_3,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "embellish";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "getnf";
    repo = "embellish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Db7/vo9LVE7IeFFHx/BKs+qxzsvuB+6ZLRb7A1NHrxQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
    blueprint-compiler
    gobject-introspection
    gtk4
    gettext
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    gjs
    gnome-autoar
    libsoup_3
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "User-friendly application designed for managing Nerd Fonts on your system";
    longDescription = ''
      Embellish provides a seamless experience for installing, uninstalling
      and updating of Nerd Fonts. It's able to:
      - List all available Nerd Fonts
      - Download and install a Font
      - Uninstall an installed Font
      - Update an installed font
      - Preview fonts
      - Search fonts
      - Read font's licence(s)
    '';
    homepage = "https://github.com/getnf/embellish";
    changelog = "https://github.com/getnf/embellish/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ normalcea ];
    mainProgram = "io.github.getnf.embellish";
    platforms = lib.platforms.linux;
  };
})
