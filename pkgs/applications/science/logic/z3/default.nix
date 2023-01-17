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

let common = { version, sha256, patches ? [ ] }:
  stdenv.mkDerivation rec {
    pname = "z3";
    inherit version sha256 patches;
    src = fetchFromGitHub {
      owner = "Z3Prover";
      repo = pname;
      rev = "z3-${version}";
      sha256 = sha256;
    };

    nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
    buildInputs = [ python ]
      ++ lib.optional javaBindings jdk
      ++ lib.optionals ocamlBindings [ ocaml findlib zarith ]
    ;
    propagatedBuildInputs = [ python.pkgs.setuptools ];
    enableParallelBuilding = true;

    postPatch = lib.optionalString ocamlBindings ''
      export OCAMLFIND_DESTDIR=$ocaml/lib/ocaml/${ocaml.version}/site-lib
      mkdir -p $OCAMLFIND_DESTDIR/stublibs
    '';

    configurePhase = lib.concatStringsSep " "
      (
        [ "${python.interpreter} scripts/mk_make.py --prefix=$out" ]
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
      description = "A high-performance theorem prover and SMT solver";
      homepage = "https://github.com/Z3Prover/z3";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ thoughtpolice ttuegel ];
    };
  };
in
{
  z3_4_11 = common {
    version = "4.11.0";
    sha256 = "sha256-ItmtZHDhCeLAVtN7K80dqyAh20o7TM4xk2sTb9QgHvk=";
  };
  z3_4_8 = common {
    version = "4.8.15";
    sha256 = "0xkwqz0y5d1lfb6kfqy8wn8n2dqalzf4c8ghmjsajc1bpdl70yc5";
  };
}
