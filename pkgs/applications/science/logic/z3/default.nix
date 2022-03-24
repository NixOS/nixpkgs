{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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

    nativeBuildInputs = optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
    buildInputs = [ python ]
      ++ optional javaBindings jdk
      ++ optionals ocamlBindings [ ocaml findlib zarith ]
    ;
    propagatedBuildInputs = [ python.pkgs.setuptools ];
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
      make test
      ./test-z3 -a
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

    outputs = [ "out" "lib" "dev" "python" ]
      ++ optional javaBindings "java"
      ++ optional ocamlBindings "ocaml";

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
  z3_4_8 = common {
    version = "4.8.15";
    sha256 = "0xkwqz0y5d1lfb6kfqy8wn8n2dqalzf4c8ghmjsajc1bpdl70yc5";
  };
  z3_4_7 = common {
    version = "4.7.1";
    sha256 = "1s850r6qifwl83zzgvrb5l0jigvmymzpv18ph71hg2bcpk7kjw3d";
  };
  z3_4_6 = common {
    version = "4.6.0";
    sha256 = "1cgwlmjdbf4rsv2rriqi2sdpz9qxihxrcpm6a4s37ijy437xg78l";
    patches = [
      # This patch is necessary for newer versions of gcc: https://github.com/Z3Prover/z3/pull/1612
      (fetchpatch {
        url = "https://github.com/Z3Prover/z3/commit/2d5dd802386d78117d5ed9ddcbf8bc22ab3cb461.patch";
        sha256 = "BZDaI9qwh0W4m0U9jZS3FdIZ8fQlqgHq3gixxD/4hDI=";
        name = "4.6.0.patch";
      })
    ];
  };
  z3_4_5 = common {
    version = "4.5.0";
    sha256 = "0ssp190ksak93hiz61z90x6hy9hcw1ywp8b2dzmbhn6fbd4bnxzp";
    patches = [
      # This patch is necessary for newer versions of clang: https://github.com/Z3Prover/z3/issues/1016
      (fetchpatch {
        url = "https://github.com/Z3Prover/z3/commit/f03f471f025adaed6f82d73b7e19fc8693bbec4f.patch";
        sha256 = "+cQoACB5f/ubgrC1ITWYueP1aksh+81aYaGuKUDwA2s=";
        name = "4.5.0.patch";
      })
    ];
  };
}
