{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  gtk3,
  gnome,
  adwaita-icon-theme,
  gdk-pixbuf,
  librsvg,
  gsound,
  libmanette,
  gettext,
  itstool,
  libxml2,
  clutter,
  clutter-gtk,
  wrapGAppsHook3,
  meson,
  ninja,
  python3,
  vala,
  desktop-file-utils,
}:

stdenv.mkDerivation rec {
  pname = "quadrapassel";
  version = "49.rc";

  src = fetchurl {
    url = "mirror://gnome/sources/quadrapassel/${lib.versions.major version}/quadrapassel-${version}.tar.xz";
    hash = "sha256-Mr71UXopmxkapqwi0XMDJZBhN15MYyadMpwOVt7bEP4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    python3
    vala
    desktop-file-utils
    pkg-config
    adwaita-icon-theme
    libxml2
    itstool
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    gdk-pixbuf
    librsvg
    libmanette
    gsound
    clutter
    libxml2
    clutter-gtk
  ];

  passthru = {
    updateScript = gnome.updateScript { packageName = "quadrapassel"; };
  };

  meta = {
    description = "Classic falling-block game, Tetris";
    mainProgram = "quadrapassel";
    homepage = "https://gitlab.gnome.org/GNOME/quadrapassel";
    changelog = "https://gitlab.gnome.org/GNOME/quadrapassel/-/blob/${version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
}
