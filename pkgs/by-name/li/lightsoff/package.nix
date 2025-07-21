{
  lib,
  stdenv,
  fetchurl,
  vala,
  pkg-config,
  glib,
  gtk4,
  libadwaita,
  gnome,
  gdk-pixbuf,
  wrapGAppsHook4,
  gettext,
  itstool,
  libxml2,
  meson,
  ninja,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "lightsoff";
  version = "48.1";

  src = fetchurl {
    url = "mirror://gnome/sources/lightsoff/${lib.versions.major version}/lightsoff-${version}.tar.xz";
    hash = "sha256-LsmVAXE9vNE8WlZaLhGMxMwrUCg2s4enc2z7pAqLOYk=";
  };

  nativeBuildInputs = [
    vala
    pkg-config
    wrapGAppsHook4
    itstool
    gettext
    libxml2
    meson
    ninja
    python3
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
    substituteInPlace build-aux/meson_post_install.py \
      --replace-fail "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "lightsoff"; };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/lightsoff";
    changelog = "https://gitlab.gnome.org/GNOME/lightsoff/-/blob/${version}/NEWS?ref_type=tags";
    description = "Puzzle game, where the objective is to turn off all of the tiles on the board";
    mainProgram = "lightsoff";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}
