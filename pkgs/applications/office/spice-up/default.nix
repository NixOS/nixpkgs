{ stdenv
, fetchFromGitHub
, gettext
, libxml2
, pkgconfig
, gtk3
, gnome3
, gobject-introspection
, json-glib
, cmake
, ninja
, libgudev
, libevdev
, libsoup
, pantheon
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
    cmake
    gettext
    gobject-introspection # For setup hook
    libxml2
    ninja
    pkgconfig
    pantheon.vala
    wrapGAppsHook
  ];
  buildInputs = [
    pantheon.elementary-icon-theme
    pantheon.granite
    gnome3.libgee
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
