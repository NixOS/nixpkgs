{ stdenv
, fetchurl
, pkgconfig
, intltool
, gnome2
, libxslt
, python
, basicmeta
}:

let
  version = "${major}.${minor}.${patch}";
  major = "0";
  minor = "14";
  patch = "6";

in stdenv.mkDerivation {
  name = "planner-${version}";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/planner/${major}.${minor}/planner-${version}.tar.xz";
    sha256 = "15h6ps58giy5r1g66sg1l4xzhjssl362mfny2x09khdqsvk2j38k";
  };

  buildInputs = [
    pkgconfig
    intltool
  ] ++ (with gnome2; [
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

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    longDescription = ''
      Planner is the GNOME project management tool.
      Its goal is to be an easy-to-use no-nonsense cross-platform
      project management application.
    '';
    platforms = platforms.all;
    maintainers = with maintainers; [ rasendubi amiloradovsky ];
  } // basicmeta;
}
