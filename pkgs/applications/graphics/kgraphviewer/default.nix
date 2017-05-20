{ stdenv, fetchurl, automoc4, cmake, gettext, perl, pkgconfig
, kdelibs4, boost, graphviz
}:

stdenv.mkDerivation rec {
  name = "kgraphviewer-${version}";
  version = "2.1.90";

  src = fetchurl {
    url = "mirror://kde/unstable/kgraphviewer/${version}/src/${name}.tar.xz";
    sha256 = "13zhjs57xavzrj4nrlqs35n35ihvzij7hgbszf5fhlp2a4d4rrqs";
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

