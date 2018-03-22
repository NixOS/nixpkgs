{ stdenv, fetchFromGitHub, python, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  name = "z3-${version}";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner  = "Z3Prover";
    repo   = "z3";
    rev    = "b0aaa4c6d7a739eb5e8e56a73e0486df46483222";
    sha256 = "1cgwlmjdbf4rsv2rriqi2sdpz9qxihxrcpm6a4s37ijy437xg78l";
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
