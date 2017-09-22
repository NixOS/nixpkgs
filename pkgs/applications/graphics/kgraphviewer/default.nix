{ stdenv, fetchurl, automoc4, cmake, gettext, perl, pkgconfig
, kdelibs4, boost, graphviz
}:

stdenv.mkDerivation rec {
  name = "kgraphviewer-${version}";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://kde/stable/kgraphviewer/${version}/src/${name}.tar.xz";
    sha256 = "1vs5x539mx26xqdljwzkh2bj7s3ydw4cb1wm9nlhgs18siw4gjl5";
  };

  buildInputs = [ kdelibs4 boost graphviz ];
  nativeBuildInputs = [ automoc4 cmake gettext perl pkgconfig ];

  meta = with stdenv.lib; {
    description = "A Graphviz dot graph viewer for KDE";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}

