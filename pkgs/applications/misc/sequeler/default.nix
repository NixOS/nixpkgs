{ stdenv, fetchFromGitHub
, vala, meson, ninja, pkgconfig, pantheon, gettext, wrapGAppsHook, python3, desktop-file-utils
, gtk3, glib, libgee, libgda, gtksourceview, libxml2, libsecret, libssh2 }:


let
  sqlGda = libgda.override {
    mysqlSupport = true;
    postgresSupport = true;
  };

in stdenv.mkDerivation rec {
  pname = "sequeler";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Alecaddd";
    repo = pname;
    rev = "v${version}";
    sha256 = "090plqnby2wxzr1waq5kz89w3269j363mgxwfz9g7qg55lddaahz";
  };

  nativeBuildInputs = [ meson ninja pkgconfig vala gettext wrapGAppsHook python3 desktop-file-utils ];

  buildInputs = [ gtk3 glib pantheon.granite libgee sqlGda gtksourceview libxml2 libsecret libssh2 ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Friendly SQL Client";
    longDescription = ''
      Sequeler is a native Linux SQL client built in Vala and Gtk. It allows you
      to connect to your local and remote databases, write SQL in a handy text
      editor with language recognition, and visualize SELECT results in a
      Gtk.Grid Widget.
    '';
    homepage = "https://github.com/Alecaddd/sequeler";
    license = licenses.gpl3;
    maintainers = [ maintainers.etu ] ++ pantheon.maintainers;
    platforms = platforms.linux;
  };
}
