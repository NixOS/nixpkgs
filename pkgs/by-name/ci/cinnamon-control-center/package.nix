{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glib,
  glib-networking,
  gettext,
  cinnamon-desktop,
  gtk3,
  libnotify,
  libxml2,
  colord,
  polkit,
  cinnamon-menus,
  networkmanager,
  libgudev,
  libwacom,
  wrapGAppsHook3,
  libnma,
  libXi,
  modemmanager,
  xorgproto,
  meson,
  ninja,
  cinnamon-translations,
  python3,
  upower,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cinnamon-control-center";
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-control-center";
    tag = finalAttrs.version;
    hash = "sha256-TjTwtTFbiC4A4qe9TIyZJtGrSymujhEgM8SpZQ92RZA=";
  };

  buildInputs = [
    gtk3
    glib
    glib-networking
    cinnamon-desktop
    libnotify
    cinnamon-menus
    polkit
    colord
    libgudev
    libwacom
    networkmanager
    libnma
    libXi
    modemmanager
    xorgproto
    upower
  ];

  postPatch = ''
    patchShebangs meson_install_schemas.py
  '';

  mesonFlags = [
    # use locales from cinnamon-translations
    "--localedir=${cinnamon-translations}/share/locale"
  ];

  nativeBuildInputs = [
    libxml2 # xmllint
    pkg-config
    meson
    ninja
    wrapGAppsHook3
    gettext
    python3
  ];

  meta = {
    homepage = "https://github.com/linuxmint/cinnamon-control-center";
    description = "Collection of configuration plugins used in cinnamon-settings";
    mainProgram = "cinnamon-control-center";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
