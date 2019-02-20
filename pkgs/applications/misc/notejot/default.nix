{ stdenv, fetchFromGitHub, pkgconfig, meson, ninja, python3, pantheon
, gtk3, gtksourceview, json-glib, gnome3, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "notejot";
  version = "1.5.4";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "1lv4s2mqddi6lz414kqpp4vcwnkjibc0k2xhnczaa1wf3azlxjgf";
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
    pantheon.elementary-icon-theme
    pantheon.granite
    gnome3.libgee
    gtk3
    gtksourceview
    json-glib
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Stupidly-simple sticky notes applet";
    homepage = https://github.com/lainsce/notejot;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
