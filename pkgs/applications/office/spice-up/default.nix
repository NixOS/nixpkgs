{ stdenv
, fetchFromGitHub
, gettext
, libxml2
, pkgconfig
, gtk3
, granite
, gnome3
, gobject-introspection
, json-glib
, cmake
, ninja
, libgudev
, libevdev
, libsoup
, vala_0_40
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "spice-up-${version}";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "Philip-Scott";
    repo = "Spice-up";
    rev = version;
    sha256 = "1qb1hlw7g581dmgg5mh832ixjkcgqm3lqzj6xma2cz8wdncwwjaq";
  };

  USER = "nix-build-user";

  nativeBuildInputs = [
    pkgconfig
    wrapGAppsHook
    vala_0_40 # should be `elementary.vala` when elementary attribute set is merged
    cmake
    ninja
    gettext
    libxml2
    gobject-introspection # For setup hook
  ];
  buildInputs = [
    gnome3.defaultIconTheme # should be `elementary.defaultIconTheme`when elementary attribute set is merged
    gnome3.libgee
    granite
    gtk3
    json-glib
    libevdev
    libgudev
    libsoup
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
