{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  gnome,
  adwaita-icon-theme,
  gtk3,
  wrapGAppsHook3,
  libxml2,
  gettext,
  itstool,
  meson,
  ninja,
  python3,
  vala,
  desktop-file-utils,
}:

stdenv.mkDerivation rec {
  pname = "gnome-tetravex";
  version = "3.38.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-tetravex/${lib.versions.majorMinor version}/gnome-tetravex-${version}.tar.xz";
    hash = "sha256-g4SawGTUVuHdRrbiAcaGFSYkw9HsS5mTWYWkmqeRcss=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    itstool
    libxml2
    adwaita-icon-theme
    pkg-config
    gettext
    meson
    ninja
    python3
    vala
    desktop-file-utils
  ];

  buildInputs = [ gtk3 ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-tetravex"; };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-tetravex";
    description = "Complete the puzzle by matching numbered tiles";
    mainProgram = "gnome-tetravex";
    teams = [ teams.gnome ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
