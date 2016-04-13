{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "ltl2ba-${version}";
  version = "1.1";

  src = fetchurl {
    url    = "http://www.lsv.ens-cachan.fr/~gastin/ltl2ba/${name}.tar.gz";
    sha256 = "16z0gc7a9dkarwn0l6rvg5jdhw1q4qyn4501zlchy0zxqddz0sx6";
  };

  preConfigure = ''
    substituteInPlace Makefile \
    --replace "CC=gcc" ""
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv ltl2ba $out/bin
  '';

  meta = {
    description = "fast translation from LTL formulae to Buchi automata";
    homepage    = "http://www.lsv.ens-cachan.fr/~gastin/ltl2ba";
    license     = stdenv.lib.licenses.gpl2Plus;
    platforms   = stdenv.lib.platforms.darwin ++ stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
