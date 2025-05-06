{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
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
  version = "3.38.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-tetravex/${lib.versions.majorMinor version}/gnome-tetravex-${version}.tar.xz";
    hash = "sha256-H83xCXm5o1JgCdeDociKOJkY82DaTttE+6JccfGGkRs=";
  };

  patches = [
    # Fix build with meson 0.61
    # data/meson.build:37:0: ERROR: Function does not take positional arguments.
    # data/meson.build:59:0: ERROR: Function does not take positional arguments.
    # Taken from https://gitlab.gnome.org/GNOME/gnome-tetravex/-/merge_requests/20
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-tetravex/-/commit/80912d06f5e588f6aca966fa516103275e58d94e.patch";
      hash = "sha256-2+nFw5sJzbInibKaq3J10Ufbl3CnZWlgnUtzRTZ5G0I=";
    })
  ];

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
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
