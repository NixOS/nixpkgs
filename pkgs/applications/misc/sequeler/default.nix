{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, vala, gobjectIntrospection, gettext, wrapGAppsHook, python3, desktop-file-utils
, gtk3, glib, granite, libgee, libgda, gtksourceview, libxml2, libsecret }:


let
  version = "0.6.3";
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
    sha256 = "14a0i9y003m4pvdfp4ax7jfxvyzvyfg45zhln44rm08rfngb0f7k";
  };

  nativeBuildInputs = [ meson ninja pkgconfig vala gobjectIntrospection gettext wrapGAppsHook python3 desktop-file-utils ];

  buildInputs = [ gtk3 glib granite libgee sqlGda gtksourceview libxml2 libsecret ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

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
