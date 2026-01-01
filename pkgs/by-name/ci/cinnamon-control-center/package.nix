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
<<<<<<< HEAD
  cinnamon-menus,
=======
  libxkbfile,
  cinnamon-menus,
  libgnomekbd,
  libxklavier,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  networkmanager,
  libgudev,
  libwacom,
  wrapGAppsHook3,
<<<<<<< HEAD
  libnma,
  libXi,
  modemmanager,
  xorgproto,
=======
  glibc,
  libnma,
  modemmanager,
  xorg,
  gdk-pixbuf,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meson,
  ninja,
  cinnamon-translations,
  python3,
  upower,
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-control-center";
<<<<<<< HEAD
  version = "6.6.0";
=======
  version = "6.4.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-control-center";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-TjTwtTFbiC4A4qe9TIyZJtGrSymujhEgM8SpZQ92RZA=";
=======
    hash = "sha256-nw70sbiz3+dp40WP957hOVo/mQOg2MJknZNN5Kw/Q/0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildInputs = [
    gtk3
    glib
    glib-networking
    cinnamon-desktop
    libnotify
    cinnamon-menus
<<<<<<< HEAD
    polkit
=======
    libxml2
    polkit
    libgnomekbd
    libxklavier
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    colord
    libgudev
    libwacom
    networkmanager
    libnma
<<<<<<< HEAD
    libXi
    modemmanager
    xorgproto
=======
    modemmanager
    xorg.libXxf86misc
    xorg.libxkbfile
    gdk-pixbuf
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    libxml2 # xmllint
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pkg-config
    meson
    ninja
    wrapGAppsHook3
    gettext
    python3
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/linuxmint/cinnamon-control-center";
    description = "Collection of configuration plugins used in cinnamon-settings";
    mainProgram = "cinnamon-control-center";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
=======
  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-control-center";
    description = "Collection of configuration plugins used in cinnamon-settings";
    mainProgram = "cinnamon-control-center";
    license = licenses.gpl2;
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
