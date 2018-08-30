{ stdenv, fetchFromGitHub, autoconf, automake, libtool, gettext }:

stdenv.mkDerivation rec {

  pname = "ColPack";
  version = "1.0.10";
  name = pname + "-" + version;

  src = fetchFromGitHub {
    owner = "CSCsw";
    repo = pname;
    rev = "v" + version;
    sha256 = "1p05vry940mrjp6236c0z83yizmw9pk6ly2lb7d8rpb7j9h03glr";
  };

  buildInputs = [ autoconf automake gettext libtool ];

  configurePhase = ''
    autoreconf -vif
    ./configure --prefix=$out --enable-openmp
  '';

  meta = with stdenv.lib; {
    description = "A package comprising of implementations of algorithms for
    vertex coloring and derivative computation";
    homepage = "http://cscapes.cs.purdue.edu/coloringpage/software.htm#functionalities";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ edwtjo ];
  };

}
