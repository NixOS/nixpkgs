{ stdenv, fetchurl, getopt, which, pkgconfig, gtk } :

stdenv.mkDerivation (rec {
  name = "pqiv-0.8";

  src = fetchurl {
    url = "http://www.pberndt.com/raw//Programme/Linux/pqiv/_download/pqiv-0.8.tbz";
    sha256 = "365332bab4b13ca56da6935e7155af20658e67d323808942dce23e880466f66d";
  };

  buildInputs = [ getopt which pkgconfig gtk ];

  unpackCmd="bzip2 -d < $src | tar xvf - || fail";

  preConfigure=''
    substituteInPlace configure --replace /bin/bash "$shell"
    sed -i -e 's|$(tempfile -s.*)|temp.c|' -e 's|tempfile|mktemp|' configure
  '';

  meta = {
    description = "Rewrite of qiv (quick image viewer)";
    homepage = http://www.pberndt.com/Programme/Linux/pqiv;
  };
})
