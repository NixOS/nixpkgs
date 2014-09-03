{ stdenv, fetchurl, kdelibs, automoc4, boost, pkgconfig, graphviz, gettext }:

stdenv.mkDerivation rec {
  name = "kgraphviewer-${version}";
  version = "2.1.90";

  src = fetchurl {
    url = "mirror://kde/unstable/kgraphviewer/${version}/src/${name}.tar.xz";
    sha256 = "13zhjs57xavzrj4nrlqs35n35ihvzij7hgbszf5fhlp2a4d4rrqs";
  };

  buildInputs = [ kdelibs automoc4 boost pkgconfig graphviz gettext ];

  meta = with stdenv.lib; {
    description = "A Graphviz dot graph viewer for KDE";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}

