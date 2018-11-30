{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, python3
, gnome3, vala, gobjectIntrospection, wrapGAppsHook
, gtk3, granite
, json-glib, glib, glib-networking
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

  nativeBuildInputs = [ meson ninja pkgconfig python3 vala gobjectIntrospection wrapGAppsHook ];
  buildInputs = [
    gtk3 granite json-glib glib glib-networking
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
