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

with lib;

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

    nativeBuildInputs = optional stdenv.hostPlatform.isDarwin [
      fixDarwinDylibNames
    ];

    buildInputs = [
      python
    ] ++ optional javaBindings [
      jdk
    ] ++ optionals ocamlBindings [
      ocaml
      findlib
      zarith
    ];

    propagatedBuildInputs = [
      python.pkgs.setuptools
    ];

    enableParallelBuilding = true;

    postPatch = optionalString ocamlBindings ''
      export OCAMLFIND_DESTDIR=$ocaml/lib/ocaml/${ocaml.version}/site-lib
      mkdir -p $OCAMLFIND_DESTDIR/stublibs
    '';

    configurePhase = concatStringsSep " "
      (
        [ "${python.interpreter} scripts/mk_make.py --prefix=$out" ]
          ++ optional javaBindings "--java"
          ++ optional ocamlBindings "--ml"
          ++ optional pythonBindings "--python --pypkgdir=$out/${python.sitePackages}"
      ) + "\n" + "cd build";

    doCheck = true;

    checkPhase = ''
      runHook preCheck
      make test
      ./test-z3 -a
      runHook postCheck
    '';

    postInstall = ''
      mkdir -p $dev $lib
      mv $out/lib $lib/lib
      mv $out/include $dev/include
    '' + optionalString pythonBindings ''
      mkdir -p $python/lib
      mv $lib/lib/python* $python/lib/
      ln -sf $lib/lib/libz3${stdenv.hostPlatform.extensions.sharedLibrary} $python/${python.sitePackages}/z3/lib/libz3${stdenv.hostPlatform.extensions.sharedLibrary}
    '' + optionalString javaBindings ''
      mkdir -p $java/share/java
      mv com.microsoft.z3.jar $java/share/java
      moveToOutput "lib/libz3java.${stdenv.hostPlatform.extensions.sharedLibrary}" "$java"
    '';

    outputs = [
      "out"
      "lib"
      "dev"
      "python"
    ] ++ optional javaBindings [
      "java"
    ] ++ optional ocamlBindings [
      "ocaml"
    ];

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
  z3_4_10 = common {
    version = "4.10.2";
    sha256 = "sha256-xCDQ2PrpyU7/LzOWRgCAGI1k/HO1gAkE5iYejyeNUqw=";
  };
  z3_4_8 = common {
    version = "4.8.15";
    sha256 = "0xkwqz0y5d1lfb6kfqy8wn8n2dqalzf4c8ghmjsajc1bpdl70yc5";
  };
  z3_4_7 = common {
    version = "4.7.1";
    sha256 = "1s850r6qifwl83zzgvrb5l0jigvmymzpv18ph71hg2bcpk7kjw3d";
  };
}
