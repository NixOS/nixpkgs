{ stdenv
, fetchFromGitLab
, fetchpatch
, appstream-glib
, desktop-file-utils
, fwupd
, gettext
, glib
, gtk3
, libsoup
, libxmlb
, meson
, ninja
, pkgconfig
, systemd
, help2man
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-firmware-updater";
  version = "3.34.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "hughsie";
    repo = "gnome-firmware-updater";
    rev = version;
    sha256 = "04pll0fzf4nr276kfw89r0524s6ppmls5rz4vq2j8c8gb50g0b6l";
  };

  patches = [
    # Fixes manual build
    (fetchpatch {
      url = "https://gitlab.gnome.org/hughsie/gnome-firmware-updater/commit/006b64dcb401d8c81a33222bc4be8274c23f3c9c.patch";
      sha256 = "02303ip4ri5pv1bls8c0njb00qhn0jd0d8rmvsrig0fmacwfvc06";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/hughsie/gnome-firmware-updater/commit/c4f076f2c902080618e0c27dec924fd0019f68a3.patch";
      sha256 = "1yfxd7qsg3gwpamg0m2sbcfrgks59w70r9728arrc4pwx1hia2q1";
    })
  ];

  nativeBuildInputs = [
    appstream-glib # for ITS rules
    desktop-file-utils
    gettext
    help2man
    meson
    ninja
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    fwupd
    glib
    gtk3
    libsoup
    libxmlb
    systemd
  ];

  mesonFlags = [
    "-Dconsolekit=false"
  ];

  meta = with stdenv.lib; {
    homepage = "https://gitlab.gnome.org/hughsie/gnome-firmware-updater";
    description = "Tool for installing firmware on devices";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
