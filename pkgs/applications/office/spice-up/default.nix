{ stdenv
, fetchFromGitHub
, gettext
, libxml2
, pkgconfig
, gtk3
, granite
, gnome3
, json-glib
, cmake
, ninja
, libgudev
, libevdev
, vala
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "spice-up-${version}";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "Philip-Scott";
    repo = "Spice-up";
    rev = version;
    sha256 = "087cdi7na93pgz7vf046h94v5ydvpiccpwhllq85ix8g4pa5rp85";
  };
  USER = "nix-build-user";

  XDG_DATA_DIRS = stdenv.lib.concatStringsSep ":" [
    "${granite}/share"
    "${gnome3.libgee}/share"
  ];

  nativeBuildInputs = [
    pkgconfig
    wrapGAppsHook
    vala
    cmake
    ninja
    gettext
    libxml2
  ];
  buildInputs = [
    gtk3
    granite
    gnome3.libgee
    json-glib
    libgudev
    libevdev
    gnome3.gnome-themes-standard
  ];

  meta = with stdenv.lib; {
    description = "Create simple and beautiful presentations on the Linux desktop";
    homepage = https://github.com/Philip-Scott/Spice-up;
    maintainers = with maintainers; [ samdroid-apps ];
    platforms = platforms.linux;
    # The COPYING file has GPLv3; some files have GPLv2+ and some have GPLv3+
    license = licenses.gpl3Plus;
  };
}
