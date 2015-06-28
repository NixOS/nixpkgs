{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "picosat-${version}";
  version = "960";

  src = fetchurl {
    url = "http://fmv.jku.at/picosat/${name}.tar.gz";
    sha256 = "05z8cfjk84mkna5ryqlq2jiksjifg3jhlgbijaq36sbn0i51iczd";
  };

  dontAddPrefix = true;
  configureFlags = "--shared";

  installPhase = ''
   mkdir -p $out/bin $out/lib $out/include/picosat
   cp picomus "$out"/bin
   cp picosat "$out"/bin

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
