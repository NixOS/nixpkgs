{
  lib,
  stdenv,
  fetchFromGitHub,
  blueprint-compiler,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  appstream,
  flatpak,
  glib-networking,
  glycin-loaders,
  gtk4,
  json-glib,
  libadwaita,
  libdex,
  libglycin,
  libglycin-gtk4,
  libproxy,
  libsoup_3,
  libxmlb,
  libxml2,
  libyaml,
  malcontent,
  md4c,
  webkitgtk_6_0,
  libsecret,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bazaar";
  version = "0.7.12";

  src = fetchFromGitHub {
    owner = "kolunmi";
    repo = "bazaar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6FWRYzxakUbK2ch+6j2hJAY21qbehYD4CHhCQoneG2M=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    libxml2
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    appstream
    flatpak
    glib-networking
    gtk4
    json-glib
    libadwaita
    libdex
    libglycin
    libglycin-gtk4
    glycin-loaders
    libproxy
    libsoup_3
    libxmlb
    libyaml
    malcontent
    md4c
    webkitgtk_6_0
    libsecret
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "FlatHub-first app store for GNOME";
    homepage = "https://github.com/kolunmi/bazaar";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      dtomvan
    ];
    mainProgram = "bazaar";
    platforms = lib.platforms.linux;
  };
})
