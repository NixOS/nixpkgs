{ lib
, stdenv
, cmake
, fetchFromGitHub
, python
, fixDarwinDylibNames
, javaBindings ? false
, ocamlBindings ? false
, pythonBindings ? true
, jdk ? null
, ocaml ? null
, findlib ? null
, zarith ? null
}:

with lib;

stdenv.mkDerivation rec {
  pname = "z3";
  version = "4.8.12";

  src = fetchFromGitHub {
    owner = "Z3Prover";
    repo = pname;
    rev = "z3-${version}";
    sha256 = "1wbcdc7h3mag8infspvxxja2hiz4igjwxzvss2kqar1rjj4ivfx0";
  };

  nativeBuildInputs = optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs = [ cmake ] ;
  propagatedBuildInputs = [ python.pkgs.setuptools ];
  enableParallelBuilding = true;

  cmakeFlags = [];

  outputs = [ "out" "lib" "dev" ] ;

  meta = with lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage = "https://github.com/Z3Prover/z3";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ttuegel ];
  };
}
