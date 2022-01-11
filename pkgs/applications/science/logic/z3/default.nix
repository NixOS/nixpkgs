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
