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
  libxkbfile,
  cinnamon-menus,
  libgnomekbd,
  libxklavier,
  networkmanager,
  libgudev,
  libwacom,
  wrapGAppsHook3,
  glibc,
  libnma,
  modemmanager,
  xorg,
  gdk-pixbuf,
  meson,
  ninja,
  cinnamon-translations,
  python3,
  upower,
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-control-center";
  version = "6.4.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-control-center";
    rev = version;
    hash = "sha256-nw70sbiz3+dp40WP957hOVo/mQOg2MJknZNN5Kw/Q/0=";
  };

  buildInputs = [
    gtk3
    glib
    glib-networking
    cinnamon-desktop
    libnotify
    cinnamon-menus
    libxml2
    polkit
    libgnomekbd
    libxklavier
    colord
    libgudev
    libwacom
    networkmanager
    libnma
    modemmanager
    xorg.libXxf86misc
    xorg.libxkbfile
    gdk-pixbuf
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
    pkg-config
    meson
    ninja
    wrapGAppsHook3
    gettext
    python3
  ];

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-control-center";
    description = "Collection of configuration plugins used in cinnamon-settings";
    mainProgram = "cinnamon-control-center";
    license = licenses.gpl2;
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
