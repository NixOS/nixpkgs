{ stdenv, fetchurl
, pkgconfig
, intltool
, gnome
, libxslt
, python
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
    gnome.GConf
    gnome.gtk
    gnome.libgnomecanvas
    gnome.libgnomeui
    gnome.libglade
    gnome.scrollkeeper
    libxslt
    python
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Planner/;
    description = "Project management application for GNOME";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.rasendubi ];
  };
}
