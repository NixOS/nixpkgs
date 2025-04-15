{
  lib,
  fetchFromGitHub,
  accountsservice,
  appstream-glib,
  dbus,
  desktop-file-utils,
  gettext,
  glib,
  gobject-introspection,
  gsettings-desktop-schemas,
  gtk-layer-shell,
  gtk3,
  json-glib,
  libgee,
  libhandy,
  libpulseaudio,
  libxml2,
  meson,
  ninja,
  pantheon,
  pkg-config,
  python3,
  stdenv,
  vala,
  wrapGAppsHook3,
  blueprint-compiler,
  gtk4,
  libadwaita,
  udisks,
  libgtop,
  gtk4-layer-shell,
}:

stdenv.mkDerivation rec {
  pname = "swaysettings";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwaySettings";
    tag = "v${version}";
    hash = "sha256-XP0Q3Q40cvAl3MEqShY+VMWjlCtqs9e91nkxocVNQQQ=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook3
    gobject-introspection
    blueprint-compiler
    udisks
    libgtop
    gtk4-layer-shell
  ];

  buildInputs = [
    accountsservice
    dbus
    glib
    gsettings-desktop-schemas
    gtk-layer-shell
    gtk3
    json-glib
    libgee
    libhandy
    libpulseaudio
    libxml2
    pantheon.granite7
    gtk4
    libadwaita
  ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  meta = {
    description = "GUI for configuring your sway desktop";
    longDescription = ''
      Sway settings enables easy configuration of a sway desktop environment
      such as selection of application or icon themes.
    '';
    homepage = "https://github.com/ErikReider/SwaySettings";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.aacebedo ];
  };
}
