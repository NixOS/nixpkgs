{ lib
, fetchFromGitHub
, accountsservice
, appstream-glib
, dbus
, desktop-file-utils
, gettext
, glib
, gobject-introspection
, gsettings-desktop-schemas
, gtk3
, json-glib
, libgee
, libhandy
, libxml2
, meson
, ninja
, pantheon
, pkg-config
, python3
, stdenv
, vala
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "swaysettings";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwaySettings";
    rev = "v${version}";
    hash = "sha256-2bbB+37t6chbdnOSpIolAsy7aD9i1UizWqkcF8Frfsk=";
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
    dbus
    glib
    gobject-introspection
    gsettings-desktop-schemas
    gtk3
    json-glib
    libgee
    libhandy
    libxml2
    pantheon.granite
  ];

  postPatch = ''
    patchShebangs /build/source/build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    description = "A GUI for configuring your sway desktop";
    longDescription = ''
      Sway settings enables easy configuration of a sway desktop environment
      such as selection of application or icon themes.
    '';
    homepage = "https://github.com/ErikReider/SwaySettings";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.aacebedo ];
  };
}
