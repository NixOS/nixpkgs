{ stdenv, fetchurl, getopt, which, pkgconfig, gtk } :

stdenv.mkDerivation (rec {
  name = "pqiv-0.12";

  src = fetchurl {
    url = "https://github.com/downloads/phillipberndt/pqiv/${name}.tbz";
    sha256 = "646c69f2f4e7289913f6b8e8ae984befba9debf0d2b4cc8af9955504a1fccf1e";
  };

  buildInputs = [ getopt which pkgconfig gtk ];

  preConfigure=''
    substituteInPlace configure --replace /bin/bash "$shell"
    sed -i -e 's|$(tempfile -s.*)|temp.c|' -e 's|tempfile|mktemp|' configure
  '';

  unpackCmd = ''
    tar -xf ${src}
  '';

  meta = {
    description = "Rewrite of qiv (quick image viewer)";
    homepage = http://www.pberndt.com/Programme/Linux/pqiv;
  };
})
