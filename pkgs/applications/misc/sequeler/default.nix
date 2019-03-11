{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, pantheon, gobject-introspection, gettext, wrapGAppsHook, python3, desktop-file-utils
, gtk3, glib, libgee, libgda, gtksourceview, libxml2, libsecret, libfixposix, libssh2 }:


let
  version = "0.6.7";
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
    sha256 = "0sxmky27pl0aqnh857xb54rnfg1kbr2smdzyrzw67cbv00f6d30p";
  };

  nativeBuildInputs = [ meson ninja pkgconfig pantheon.vala gobject-introspection gettext wrapGAppsHook python3 desktop-file-utils ];

  buildInputs = [ gtk3 glib pantheon.granite libgee sqlGda gtksourceview libxml2 libsecret libfixposix libssh2 ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
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
