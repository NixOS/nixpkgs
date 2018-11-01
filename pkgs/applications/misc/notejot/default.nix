{ stdenv, fetchFromGitHub, vala, pkgconfig, meson, ninja, python3, granite
, gtk3, gnome3, gtksourceview, json-glib, gobjectIntrospection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "notejot";
  version = "1.4.5";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "0mjig4y2rb6v2dyzya44mfz0dxgp5wnjs3kdavf9ha2jzjjr5xyb";
  };

  nativeBuildInputs = [
    gobjectIntrospection
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gnome3.libgee
    granite
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
    homepage    = https://github.com/lainsce/notejot;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms   = platforms.linux;
  };
}
