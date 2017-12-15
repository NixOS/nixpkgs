{ stdenv, fetchFromGitHub, python2, fixDarwinDylibNames }:

let
  python = python2;
in stdenv.mkDerivation rec {
  name = "z3-${version}";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner  = "Z3Prover";
    repo   = "z3";
    rev    = "z3-4.5.0";
    sha256 = "0ssp190ksak93hiz61z90x6hy9hcw1ywp8b2dzmbhn6fbd4bnxzp";
  };

  buildInputs = [ python fixDarwinDylibNames ];
  enableParallelBuilding = true;

  configurePhase = ''
    ${python.interpreter} scripts/mk_make.py --prefix=$out --python --pypkgdir=$out/${python.sitePackages}
    cd build
  '';

  meta = {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = "https://github.com/Z3Prover/z3";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
