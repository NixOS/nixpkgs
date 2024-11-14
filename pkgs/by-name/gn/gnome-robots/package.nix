{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnome,
  gtk3,
  wrapGAppsHook3,
  librsvg,
  gsound,
  gettext,
  itstool,
  libxml2,
  libgnome-games-support,
  libgee,
  meson,
  ninja,
  vala,
  python3,
  desktop-file-utils,
  adwaita-icon-theme,
}:

stdenv.mkDerivation rec {
  pname = "gnome-robots";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-robots/${lib.versions.major version}/gnome-robots-${version}.tar.xz";
    hash = "sha256-b78viFdQ8aURCnJPjzWt3ZvGEYTuMc8MDLiZU+T0yxE=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    vala
    python3
    libxml2
    wrapGAppsHook3
    gettext
    itstool
    desktop-file-utils
  ];

  buildInputs = [
    gtk3
    librsvg
    gsound
    libgnome-games-support
    libgee
    adwaita-icon-theme
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-robots"; };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-robots";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-robots/-/blob/${version}/NEWS?ref_type=tags";
    description = "Avoid the robots and make them crash into each other";
    mainProgram = "gnome-robots";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
