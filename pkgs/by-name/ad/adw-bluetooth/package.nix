{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  blueprint-compiler,
  typescript,
  desktop-file-utils,
  wrapGAppsHook4,
  gjs,
  libadwaita,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "adw-bluetooth";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ezratweaver";
    repo = "adw-bluetooth";
    tag = finalAttrs.version;
    hash = "sha256-/KJpB9i6tFDnB3C0tPtJtt8tTDfNftIkHmP1JSVSZNY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    blueprint-compiler
    typescript
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    gjs
    libadwaita
  ];

  meta = {
    description = "GNOME Inspired LibAdwaita Bluetooth Applet";
    homepage = "https://github.com/ezratweaver/adw-bluetooth";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ezratweaver ];
  };
})
