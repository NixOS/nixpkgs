{ lib
, stdenv
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
, writeScript
}:

assert javaBindings -> jdk != null;
assert ocamlBindings -> ocaml != null && findlib != null && zarith != null;

let common = { version, sha256, patches ? [ ], tag ? "z3" }:
  stdenv.mkDerivation rec {
    pname = "z3";
    inherit version sha256 patches;
    src = fetchFromGitHub {
      owner = "Z3Prover";
      repo = "z3";
      rev = "${tag}-${version}";
      sha256 = sha256;
    };

    strictDeps = true;

    nativeBuildInputs = [ python ]
      ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames
      ++ lib.optional javaBindings jdk
      ++ lib.optionals ocamlBindings [ ocaml findlib ]
    ;
    propagatedBuildInputs = [ python.pkgs.setuptools ]
      ++ lib.optionals ocamlBindings [ zarith ];
    enableParallelBuilding = true;

    postPatch = lib.optionalString ocamlBindings ''
      export OCAMLFIND_DESTDIR=$ocaml/lib/ocaml/${ocaml.version}/site-lib
      mkdir -p $OCAMLFIND_DESTDIR/stublibs
    '';

    configurePhase = lib.concatStringsSep " "
      (
        [ "${python.pythonOnBuildForHost.interpreter} scripts/mk_make.py --prefix=$out" ]
          ++ lib.optional javaBindings "--java"
          ++ lib.optional ocamlBindings "--ml"
          ++ lib.optional pythonBindings "--python --pypkgdir=$out/${python.sitePackages}"
      ) + "\n" + "cd build";

    doCheck = true;
    checkPhase = ''
      make test
      ./test-z3 -a
    '';

    postInstall = ''
      mkdir -p $dev $lib
      mv $out/lib $lib/lib
      mv $out/include $dev/include
    '' + lib.optionalString pythonBindings ''
      mkdir -p $python/lib
      mv $lib/lib/python* $python/lib/
      ln -sf $lib/lib/libz3${stdenv.hostPlatform.extensions.sharedLibrary} $python/${python.sitePackages}/z3/lib/libz3${stdenv.hostPlatform.extensions.sharedLibrary}
    '' + lib.optionalString javaBindings ''
      mkdir -p $java/share/java
      mv com.microsoft.z3.jar $java/share/java
      moveToOutput "lib/libz3java.${stdenv.hostPlatform.extensions.sharedLibrary}" "$java"
    '';

    outputs = [ "out" "lib" "dev" "python" ]
      ++ lib.optional javaBindings "java"
      ++ lib.optional ocamlBindings "ocaml";

    meta = with lib; {
      description = "High-performance theorem prover and SMT solver";
      mainProgram = "z3";
      homepage = "https://github.com/Z3Prover/z3";
      changelog = "https://github.com/Z3Prover/z3/releases/tag/z3-${version}";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ thoughtpolice ttuegel ];
    };
  };
in
{
  z3_4_12 = common {
    version = "4.12.5";
    sha256 = "sha256-Qj9w5s02OSMQ2qA7HG7xNqQGaUacA1d4zbOHynq5k+A=";
  };
  z3_4_11 = common {
    version = "4.11.2";
    sha256 = "sha256-OO0wtCvSKwGxnKvu+AfXe4mEzv4nofa7A00BjX+KVjc=";
  };
  z3_4_8 = common {
    version = "4.8.17";
    sha256 = "sha256-BSwjgOU9EgCcm18Zx0P9mnoPc9ZeYsJwEu0ffnACa+8=";
  };
  z3_4_8_5 = common {
    tag = "Z3";
    version = "4.8.5";
    sha256 = "sha256-ytG5O9HczbIVJAiIGZfUXC/MuYH7d7yLApaeTRlKXoc=";
  };
}
