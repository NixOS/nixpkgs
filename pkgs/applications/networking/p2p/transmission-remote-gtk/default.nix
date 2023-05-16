<<<<<<< HEAD
{ lib
, stdenv
, appstream-glib
, curl
, desktop-file-utils
, fetchFromGitHub
, geoip
, gettext
, glib
, gtk3
, json-glib
, libappindicator
, libmrss
, libproxy
, libsoup_3
, meson
, ninja
, pkg-config
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "transmission-remote-gtk";
  version = "1.6.0";
=======
{ lib, stdenv, wrapGAppsHook, fetchFromGitHub, pkg-config, gtk3, json-glib, curl
, glib, appstream-glib, desktop-file-utils, meson, ninja, geoip, gettext
, libappindicator, libmrss, libproxy }:

stdenv.mkDerivation rec {
  pname = "transmission-remote-gtk";
  version = "1.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "transmission-remote-gtk";
    repo = "transmission-remote-gtk";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-/syZI/5LhuYLvXrNknnpbGHEH0z5iHeye2YRNJFWZJ0=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    curl
    geoip
    gettext
    glib
    gtk3
    json-glib
    libappindicator
    libmrss
    libproxy
    libsoup_3
  ];
=======
    rev = version;
    sha256 = "4/ID12JukDDvJzWupc76r7W8Us5erwv8oXZhDnB6VDk=";
  };

  nativeBuildInputs =
    [ desktop-file-utils wrapGAppsHook meson ninja pkg-config appstream-glib ];

  buildInputs =
    [ gtk3 json-glib curl glib gettext libmrss geoip libproxy libappindicator ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false; # Requires network access

  meta = with lib; {
    description = "GTK remote control for the Transmission BitTorrent client";
<<<<<<< HEAD
    homepage = "https://github.com/transmission-remote-gtk/transmission-remote-gtk";
    changelog = "https://github.com/transmission-remote-gtk/transmission-remote-gtk/releases/tag/${version}";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
=======
    homepage =
      "https://github.com/transmission-remote-gtk/transmission-remote-gtk";
    license = licenses.gpl2;
    maintainers = [ maintainers.ehmry ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
  };
}
