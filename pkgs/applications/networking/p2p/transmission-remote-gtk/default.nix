{ lib, stdenv, wrapGAppsHook, fetchFromGitHub, pkg-config, gtk3, json-glib, curl
, glib, appstream-glib, desktop-file-utils, meson, ninja, geoip, gettext
, libappindicator, libmrss, libproxy }:

stdenv.mkDerivation rec {
  pname = "transmission-remote-gtk";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "transmission-remote-gtk";
    repo = "transmission-remote-gtk";
    rev = version;
    sha256 = "4/ID12JukDDvJzWupc76r7W8Us5erwv8oXZhDnB6VDk=";
  };

  nativeBuildInputs =
    [ desktop-file-utils wrapGAppsHook meson ninja pkg-config appstream-glib ];

  buildInputs =
    [ gtk3 json-glib curl glib gettext libmrss geoip libproxy libappindicator ];

  doCheck = false; # Requires network access

  meta = with lib; {
    description = "GTK remote control for the Transmission BitTorrent client";
    homepage =
      "https://github.com/transmission-remote-gtk/transmission-remote-gtk";
    license = licenses.gpl2;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.linux;
  };
}
