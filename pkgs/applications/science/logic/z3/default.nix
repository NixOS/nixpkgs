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
}:

assert javaBindings -> jdk != null;
assert ocamlBindings -> ocaml != null && findlib != null && zarith != null;

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
}
