{stdenv, fetchurl }:

let
  version = "936";
  pname = "picosat";

in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://fmv.jku.at/picosat/${name}.tar.gz";
    sha256 = "02hq68fmfjs085216wsj13ff6i1rhc652yscl16w9jzpfqzly91n";
  };

  dontAddPrefix = true;

  # configureFlags = "--shared"; the ./configure file is broken and doesn't accept this parameter :(
  patchPhase = ''
   sed -e 's/^shared=no/shared=yes/' -i configure
  '';

  installPhase = ''
   mkdir -p "$out"/bin
   cp picomus "$out"/bin
   cp picosat "$out"/bin
   mkdir -p "$out"/lib
   cp libpicosat.a "$out"/lib
   cp libpicosat.so "$out"/lib
   mkdir -p "$out"/include/picosat
   cp picosat.h "$out"/include/picosat
  '';

  meta = {
    homepage = http://fmv.jku.at/picosat/;
    description = "SAT solver with proof and core support";
    license = "MIT";
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
