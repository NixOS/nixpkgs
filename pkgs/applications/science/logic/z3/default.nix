{ stdenv, fetchFromGitHub, python2, fixDarwinDylibNames }:

let
  python = python2;
in stdenv.mkDerivation rec {
  name = "z3-${version}";
  version = "4.5.0-2017-11-06";

  src = fetchFromGitHub {
    owner  = "Z3Prover";
    repo   = "z3";
    rev    = "3350f32e1f2c01c9df63b7d71899796a18ce2272";
    sha256 = "00jn0njn5h9v49pl67yxj6225m6334ndrx6mp37vcqac05pdbpw7";
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
