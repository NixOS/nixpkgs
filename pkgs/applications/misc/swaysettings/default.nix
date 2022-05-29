{ lib
, stdenv
, fetchFromGitHub
, accountsservice
, appstream-glib
, desktop-file-utils
, gettext
, glib
, gobject-introspection
, gsettings-desktop-schemas
, pantheon
, gtk-layer-shell
, gtk3
, json-glib
, libgee
, libhandy
, libxml2
, meson
, ninja
, pkg-config
, python3
, sway
, vala
, wrapGAppsHook
, xkeyboardconfig
}:

stdenv.mkDerivation rec {
  pname = "swaysettings";
  version = "2022-05-25";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwaySettings";
    rev = "c60a235061faf68ca1cf24d22b2aed73eb31e6c0";
    hash = "sha256-EVGY4LbiH+RB56sYGOkYCdOc01LqbJIg9mJjgvFd4oY=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    accountsservice
    glib
    gobject-introspection
    gsettings-desktop-schemas
    pantheon.granite
    gtk-layer-shell
    gtk3
    json-glib
    libgee
    libhandy
    libxml2
    xkeyboardconfig
  ];

  postPatch = ''
    patchShebangs ./build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    homepage = "https://github.com/ErikReider/SwaySettings";
    description = "A GUI for configuring your sway desktop";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (sway.meta) platforms;
  };
}
