{
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "ltl2ba";
  version = "1.3";

  src = fetchurl {
    url = "https://www.lsv.ens-cachan.fr/~gastin/ltl2ba/${pname}-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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
    mainProgram = "ltl2ba";
    homepage = "http://www.lsv.ens-cachan.fr/~gastin/ltl2ba";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
