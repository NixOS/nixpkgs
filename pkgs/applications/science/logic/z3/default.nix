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
, writeScript
}:

assert javaBindings -> jdk != null;

with lib;

stdenv.mkDerivation rec {
  pname = "z3";
  version = "4.8.14";

  src = fetchFromGitHub {
    owner = "Z3Prover";
    repo = pname;
    rev = "z3-${version}";
    sha256 = "jPSTVSndp/T7n+VxZ/g9Rjco00Up+9xeDIVkeLl1MTw=";
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

   passthru = {
    updateScript = writeScript "update-z3" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts curl jq

      set -eu -o pipefail

      # Expect tags in format
      #    [{name: "Nightly", ..., {name: "z3-vv.vv.vv", ...].
      # Below we extract frst "z3-vv.vv" and drop "z3-" prefix.
      newVersion="$(curl -s https://api.github.com/repos/Z3Prover/z3/releases |
          jq 'first(.[].name|select(startswith("z3-"))|ltrimstr("z3-"))' --raw-output
      )"
      update-source-version ${pname} "$newVersion"
    '';
   };

  meta = with lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage = "https://github.com/Z3Prover/z3";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ttuegel ];
  };
}
