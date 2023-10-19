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

  src = fetchFromGitHub {
    owner = "transmission-remote-gtk";
    repo = "transmission-remote-gtk";
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
  ] ++ libsoup_3.propagatedUserEnvPackages;

  doCheck = false; # Requires network access

  meta = with lib; {
    description = "GTK remote control for the Transmission BitTorrent client";
    homepage = "https://github.com/transmission-remote-gtk/transmission-remote-gtk";
    changelog = "https://github.com/transmission-remote-gtk/transmission-remote-gtk/releases/tag/${version}";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };
}
