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
, gtk-layer-shell
, gtk3
, json-glib
, libgee
, libhandy
, libpulseaudio
, libxml2
, meson
, ninja
, pantheon
, pkg-config
, python3
, stdenv
, vala
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "swaysettings";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwaySettings";
    rev = "v${version}";
    hash = "sha256-dn3n5DOAsw0FeXBkh19A2qB/5O+RyA2/Fj5PVtMOyL0=";
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
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    accountsservice
    dbus
    glib
    gsettings-desktop-schemas
    gtk-layer-shell
    gtk3
    json-glib
    libgee
    libhandy
    libpulseaudio
    libxml2
    pantheon.granite
  ];

  postPatch = ''
    patchShebangs /build/source/build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    description = "GUI for configuring your sway desktop";
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
