{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "picosat-${version}";
  version = "965";

  src = fetchurl {
    url = "http://fmv.jku.at/picosat/${name}.tar.gz";
    sha256 = "0m578rpa5rdn08d10kr4lbsdwp4402hpavrz6n7n53xs517rn5hm";
  };

  prePatch = ''
    substituteInPlace picosat.c --replace "sys/unistd.h" "unistd.h"
  '';

  configurePhase = "./configure.sh --shared --trace";

  installPhase = ''
   mkdir -p $out/bin $out/lib $out/share $out/include/picosat
   cp picomus picomcs picosat picogcnf "$out"/bin

   cp VERSION      "$out"/share/picosat.version
   cp picosat.o    "$out"/lib
   cp libpicosat.a "$out"/lib
   cp libpicosat.so "$out"/lib

   cp picosat.h "$out"/include/picosat
  '';

  meta = {
    description = "SAT solver with proof and core support";
    homepage    = http://fmv.jku.at/picosat/;
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ roconnor thoughtpolice ];
  };
}
