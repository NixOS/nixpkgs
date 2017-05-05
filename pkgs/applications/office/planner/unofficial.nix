{ stdenv
, fetchFromGitLab
, pkgconfig
, intltool
, automake111x
, autoconf
, libtool
, gnome2
, gnome3
, libxslt
, docbook_xsl
, python
, pythonPackages
, file
, basicmeta
}:

let version = "20170514+";
    doCheck = false;

in stdenv.mkDerivation {
  name = "planner-${version}";

  src = fetchFromGitLab {
    owner = "amiloradovsky";
    repo = "planner";
    rev = "d9bc19ad4451ec67de90e80a0ffa6637010d8d00";
    sha256 = "1is3jf86kzqf9641a2vm9z1v820jsh2bg2ys6d5rpdsbx8h5q3il";
  };

  buildInputs = [
    pkgconfig
    intltool
    automake111x
    autoconf
    libtool
  ] ++ (with gnome2; [
    gnome_common
    gtk_doc

    GConf
    gtk
    libgnome
    libgnomecanvas
    libgnomeui
    libglade
    scrollkeeper
  ]) ++ (with gnome3; [
    libgda
  ]) ++ [
    libxslt
    docbook_xsl
    python
    pythonPackages.pygtk
    file
  ];

  configureScript = "./autogen.sh";
  configureFlags = [ "--enable-gtk-doc" "--with-database"
                     "--enable-compile-warnings=yes"
                     "--enable-python-plugin"
                     "--enable-simple-priority-scheduling" ];
  # simple priority scheduling is experimental, not yet for production

  inherit doCheck;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
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
    platforms = platforms.all;
    maintainers = with maintainers; [ amiloradovsky ];
  } // basicmeta;
}
