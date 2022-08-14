{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, scdoc
, vala
, gtk3
, glib
, gtk-layer-shell
, dbus
, dbus-glib
, json-glib
, librsvg
, libhandy
, gobject-introspection
, gdk-pixbuf
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "SwayNotificationCenter";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayNotificationCenter";
    rev = "v${version}";
    hash = "sha256-79Kda2Mi2r38f0J12bRm9wbHiZCy9+ojPDxwlFG8EYw=";
  };

  nativeBuildInputs = [ gobject-introspection meson ninja pkg-config scdoc vala wrapGAppsHook ];

  buildInputs = [ dbus dbus-glib gdk-pixbuf glib gtk-layer-shell gtk3 json-glib libhandy librsvg ];

  meta = with lib; {
    description = "Simple notification daemon with a GUI built for Sway";
    homepage = "https://github.com/ErikReider/SwayNotificationCenter";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.berbiche ];
  };
}
