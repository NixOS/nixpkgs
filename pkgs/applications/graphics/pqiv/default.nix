{ stdenv, fetchurl, getopt, which, pkgconfig, gtk } :

stdenv.mkDerivation (rec {
  name = "pqiv-0.7.1";

  src = fetchurl {
    url = "http://www.pberndt.com/raw//Programme/Linux/pqiv/_download/pqiv-0.7.1.tbz";
    sha256 = "659c5d1d12c080dff5152325a2391e01a2c9a6ea225d1f755a98e8766f318eef";
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
