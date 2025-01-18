{
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "ltl2ba";
  version = "1.3";

  src = fetchurl {
    url = "http://www.lsv.ens-cachan.fr/~gastin/ltl2ba/${pname}-${version}.tar.gz";
    sha256 = "1bz9gjpvby4mnvny0nmxgd81rim26mqlcnjlznnxxk99575pfa4i";
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

  meta = with lib; {
    description = "Fast translation from LTL formulae to Buchi automata";
    mainProgram = "ltl2ba";
    homepage = "http://www.lsv.ens-cachan.fr/~gastin/ltl2ba";
    license = licenses.gpl2Plus;
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
