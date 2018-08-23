{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, gnome3, vala, gobjectIntrospection, wrapGAppsHook
, gtk3, granite
, json-glib, glib, glib-networking
}:

let
  pname = "tootle";
  version = "0.1.5";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "bleakgrey";
    repo = pname;
    rev = version;
    sha256 = "022h1rh1jk3m1f9al0s1rylmnqnkydyc81idfc8jf1g0frnvn5i6";
  };

  nativeBuildInputs = [ meson ninja pkgconfig vala gobjectIntrospection wrapGAppsHook ];
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
