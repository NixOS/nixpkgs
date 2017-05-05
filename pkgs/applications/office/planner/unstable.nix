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
, basicmeta
}:

let version = "20170514";
    doCheck = false;

in stdenv.mkDerivation {
  name = "planner-${version}";

  src = fetchgit {
    url = "https://git.gnome.org/browse/planner";
    rev = "23699814d5cc425b89baa20236a802f28dca7c2c";
    sha256 = "107y4nw4jfcabykcrc9q9vb2wwqk421aq5wnyk4xamycc2zlqfcf";
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
    libgnomecanvas
    libgnomeui
    libglade
    scrollkeeper
  ]) ++ [
    libxslt
    python
  ];

  configureScript = "./autogen.sh";

  inherit doCheck;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    longDescription = ''
      Planner is the GNOME project management tool.
      Its goal is to be an easy-to-use no-nonsense cross-platform
      project management application.

      Planner is a GTK+ application written in C and licensed under the
      GPLv2 or any later version. It stores its data in XML files.
      Projects can also be printed to PDF or exported to HTML
      for easy viewing from any web browser.

      Planner was originally created by Richard Hult and Mikael Hallendal
      at Imendio.
    '';
    platforms = platforms.all;
    maintainers = with maintainers; [ amiloradovsky rasendubi ];
  } // basicmeta;
}
