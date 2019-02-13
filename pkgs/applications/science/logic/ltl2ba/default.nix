{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "ltl2ba-${version}";
  version = "1.2";

  src = fetchurl {
    url    = "http://www.lsv.ens-cachan.fr/~gastin/ltl2ba/${name}.tar.gz";
    sha256 = "0vzv5g7v87r41cvdafxi6yqnk7glzxrzgavy8213k59f6v11dzlx";
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
