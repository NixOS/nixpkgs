{
  lib,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  gjs,
  glib,
  glib-networking,
  gtk4,
  libadwaita,
  libportal,
  libsecret,
  libsoup_3,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "forge-sparks";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "forge-sparks";
    rev = finalAttrs.version;
    hash = "sha256-4FzMhHE4601laKHYRN3NCZ7oBDH/2HaeCS9CdbmTNx0=";
    fetchSubmodules = true;
  };

  patches = [
    # XdpGtk4 is imported but not used so we remove it to avoid the dependence on libportal-gtk4
    ./remove-xdpgtk4-import.patch
  ];

  postPatch = ''
    patchShebangs troll/gjspack/bin/gjspack
  '';

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    gjs
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    glib-networking
    gtk4
    libadwaita
    libportal
    libsecret
    libsoup_3
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/rafaelmardojai/forge-sparks/releases/tag/${finalAttrs.version}";
    description = "Get Git forges notifications";
    homepage = "https://github.com/rafaelmardojai/forge-sparks";
    license = lib.licenses.mit;
    mainProgram = "forge-sparks";
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
  };
})
