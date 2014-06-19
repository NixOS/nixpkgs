{ stdenv, fetchurl, bison, flex, texinfo, readline, texLive }:

let
  name    = "eukleides";
  version = "1.5.4";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "http://www.eukleides.org/files/${name}-${version}.tar.bz2";
    sha256 = "0s8cyh75hdj89v6kpm3z24i48yzpkr8qf0cwxbs9ijxj1i38ki0q";
  };

  buildInputs = [bison flex texinfo readline texLive];

  preConfigure = "sed -i 's/ginstall-info/install-info/g' doc/Makefile";
  installPhase = "mkdir -p $out/bin ; make PREFIX=$out install";

  meta = {
    description = "Geometry Drawing Language";
    homepage = "http://www.eukleides.org/";
    license = stdenv.lib.licenses.gpl2;

    longDescription = ''
      Eukleides is a computer language devoted to elementary plane
      geometry. It aims to be a fairly comprehensive system to create
      geometric figures, either static or dynamic. Eukleides allows to
      handle basic types of data: numbers and strings, as well as
      geometric types of data: points, vectors, sets (of points), lines,
      circles and conics.
    '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
