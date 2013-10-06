{stdenv, fetchurl, polyml, experimentalKernel ? false}:

let
  pname = "hol4";
  version = "k.7";
  kernelFlag = if experimentalKernel then "-expk" else "-stdknl";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = mirror://sourceforge/hol/hol/kananaskis-7/kananaskis-7.tar.gz;
    sha256 = "0gs1nmjvsjhnndama9v7gids2g86iip53v7d7dm3sfq6jxmqkwkl";
  };

  buildInputs = [polyml];

  buildCommand = ''
    mkdir -p "$out/src"
    cd  "$out/src"

    tar -xzf "$src"
    cd hol4.${version}

    substituteInPlace tools/Holmake/Holmake_types.sml \
      --replace "\"/bin/mv\"" "\"mv\"" \
      --replace "\"/bin/cp\"" "\"cp\""

    #sed -ie "/compute/,999 d" tools/build-sequence # for testing

    poly < tools/smart-configure.sml
    
    bin/build ${kernelFlag} -symlink

    mkdir -p "$out/bin"
    ln -st $out/bin  $out/src/hol4.${version}/bin/*
    # ln -s $out/src/hol4.${version}/bin $out/bin
  '';

  meta = {
    description = "Interactive theorem prover based on Higher-Order Logic";
    longDescription = ''
      HOL4 is the latest version of the HOL interactive proof
      assistant for higher order logic: a programming environment in
      which theorems can be proved and proof tools
      implemented. Built-in decision procedures and theorem provers
      can automatically establish many simple theorems (users may have
      to prove the hard theorems themselves!) An oracle mechanism
      gives access to external programs such as SMT and BDD
      engines. HOL4 is particularly suitable as a platform for
      implementing combinations of deduction, execution and property
      checking.
    '';
    homepage = "http://hol.sourceforge.net/";
    license = "BSD";
  };
}
