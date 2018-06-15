{ stdenv, fetchFromGitHub, python, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  name = "z3-${version}";
  version = "4.7.1";

  src = fetchFromGitHub {
    owner  = "Z3Prover";
    repo   = "z3";
    rev    = "3b1b82bef05a1b5fd69ece79c80a95fb6d72a990";
    sha256 = "1s850r6qifwl83zzgvrb5l0jigvmymzpv18ph71hg2bcpk7kjw3d";
  };

  buildInputs = [ python fixDarwinDylibNames ];
  propagatedBuildInputs = [ python.pkgs.setuptools ];
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
