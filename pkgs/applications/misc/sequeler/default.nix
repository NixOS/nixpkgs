{ stdenv, fetchFromGitHub
, cmake, ninja, pkgconfig, vala, gobjectIntrospection, gettext, wrapGAppsHook
, gtk3, glib, granite, libgee, libgda, gtksourceview, libxml2 }:


let
  version = "0.5.4";
  sqlGda = libgda.override {
    mysqlSupport = true;
    postgresSupport = true;
  };

in stdenv.mkDerivation rec {
  name = "sequeler-${version}";

  src = fetchFromGitHub {
    owner = "Alecaddd";
    repo = "sequeler";
    rev = "v${version}";
    sha256 = "05c7y6xdyq3h9bn90pbz03jhy9kabmgpxi4zz0i26q0qphljskbx";
  };

  nativeBuildInputs = [ cmake ninja pkgconfig vala gobjectIntrospection gettext wrapGAppsHook ];

  buildInputs = [ gtk3 glib granite libgee sqlGda gtksourceview libxml2 ];

  meta = with stdenv.lib; {
    description = "Friendly SQL Client";
    longDescription = ''
      Sequeler is a native Linux SQL client built in Vala and Gtk. It allows you
      to connect to your local and remote databases, write SQL in a handy text
      editor with language recognition, and visualize SELECT results in a
      Gtk.Grid Widget.
    '';
    homepage = https://github.com/Alecaddd/sequeler;
    license = licenses.gpl3;
    maintainers = [ maintainers.etu ];
    platforms = platforms.linux;
  };
}
