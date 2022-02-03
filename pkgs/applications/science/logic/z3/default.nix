{ lib
, stdenv
, cmake
, fetchFromGitHub
, python
, fixDarwinDylibNames
, javaBindings ? false
, pythonBindings ? true
, jdk ? null
, ocaml ? null
, findlib ? null
, zarith ? null
}:

assert javaBindings -> jdk != null;

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
  buildInputs = [ cmake ]
    ++ optional javaBindings jdk
  ;
  propagatedBuildInputs = [ python.pkgs.setuptools ];
  enableParallelBuilding = true;

  cmakeFlags = lib.optionals javaBindings [
    "-DZ3_BUILD_JAVA_BINDINGS=True"
    "-DZ3_INSTALL_JAVA_BINDINGS=True"
  ];

  outputs = [ "out" "lib" "dev" ];

  meta = with lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage = "https://github.com/Z3Prover/z3";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ttuegel ];
  };
}
