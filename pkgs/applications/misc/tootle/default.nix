{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, python3
, gnome3, pantheon, gobject-introspection, wrapGAppsHook
, gtk3, json-glib, glib, glib-networking, hicolor-icon-theme
}:

let
  pname = "tootle";
  version = "0.2.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "bleakgrey";
    repo = pname;
    rev = version;
    sha256 = "1z3wyx316nns6gi7vlvcfmalhvxncmvcmmlgclbv6b6hwl5x2ysi";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    pantheon.vala
    wrapGAppsHook
  ];
  buildInputs = [
    gtk3 pantheon.granite json-glib glib glib-networking hicolor-icon-theme
    gnome3.libgee gnome3.libsoup gnome3.gsettings-desktop-schemas
  ];

  postPatch = ''
    chmod +x ./meson/post_install.py
    patchShebangs ./meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Simple Mastodon client designed for elementary OS";
    homepage    = https://github.com/bleakgrey/tootle;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
