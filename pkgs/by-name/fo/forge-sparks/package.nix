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
  pkg-config,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "forge-sparks";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "forge-sparks";
    rev = finalAttrs.version;
    hash = "sha256-H607u/VBuzzoYrYZc8fLqCQMZ+jRJOVZ34U8yKHfmYk=";
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

  meta = with lib; {
    changelog = "https://github.com/rafaelmardojai/forge-sparks/releases/tag/${finalAttrs.version}";
    description = "Get Git forges notifications";
    homepage = "https://github.com/rafaelmardojai/forge-sparks";
    license = licenses.mit;
    mainProgram = "forge-sparks";
    maintainers = with maintainers; [ michaelgrahamevans ];
    platforms = platforms.linux;
  };
})
