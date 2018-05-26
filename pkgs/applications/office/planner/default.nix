{ stdenv
, fetchgit
, pkgconfig
, intltool
, automake111x
, autoconf
, libtool
, gnome2
, libxslt
, python
}:

let version = "20170425";

in stdenv.mkDerivation {
  name = "planner-${version}";

  src = fetchgit {
    url = "https://git.gnome.org/browse/planner";
    rev = "6a79647e5711b2b8d7435cacc3452e643d2f05e6";
    sha256 = "18k40s0f665qclrzvkgyfqmvjk0nqdc8aj3m8n4ky85di4qbqlwd";
  };

  buildInputs = with gnome2; [
    pkgconfig
    intltool
    automake111x
    autoconf
    libtool

    gnome-common
    gtk-doc

    GConf
    gtk
    libgnomecanvas
    libgnomeui
    libglade
    scrollkeeper

    libxslt
    python
  ];

  preConfigure = ''./autogen.sh'';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Planner;
    description = "Project management application for GNOME";
    longDescription = ''
      Planner is the GNOME project management tool.
      Its goal is to be an easy-to-use no-nonsense cross-platform
      project management application.

      Planner is a GTK+ application written in C and licensed under the
      GPLv2 or any later version. It can store its data in either xml
      files or in a postgresql database. Projects can also be printed
      to PDF or exported to HTML for easy viewing from any web browser.

      Planner was originally created by Richard Hult and Mikael Hallendal
      at Imendio.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ rasendubi amiloradovsky ];
  };
}
