{ stdenv
, fetchFromGitHub
, gettext
, libxml2
, pkgconfig
, gtk3
, granite
, gnome3
, json_glib
, cmake
, ninja
, libgudev
, libevdev
, vala
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "spice-up-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Philip-Scott";
    repo = "Spice-up";
    rev = version;
    sha256 = "0cbyhi6d99blv33183j6nakzcqxz5hqy9ijykiasbmdycfd5q0fh";
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
    json_glib
    libgudev
    libevdev
    gnome3.gnome_themes_standard
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
