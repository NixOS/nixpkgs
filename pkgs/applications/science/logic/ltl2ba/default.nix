{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "ltl2ba-${version}";
  version = "1.2b1";

  src = fetchurl {
    url    = "http://www.lsv.ens-cachan.fr/~gastin/ltl2ba/${name}.tar.gz";
    sha256 = "1f4jnkfkyj8lcc5qfqbiypfc11rhhpqqi6xs9xx5dysg6r6303wm";
  };

  hardeningDisable = [ "format" ];

  preConfigure = ''
    substituteInPlace Makefile \
    --replace "CC=gcc" ""
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv ltl2ba $out/bin
  '';

  meta = {
    description = "Fast translation from LTL formulae to Buchi automata";
    homepage    = "http://www.lsv.ens-cachan.fr/~gastin/ltl2ba";
    license     = stdenv.lib.licenses.gpl2Plus;
    platforms   = stdenv.lib.platforms.darwin ++ stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
