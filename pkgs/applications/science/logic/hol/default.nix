{stdenv, fetchurl, polyml}:

stdenv.mkDerivation {
  name = "hol";

  src = fetchurl {
    #url = "http://downloads.sourceforge.net/project/hol/hol/kananaskis-5/kananaskis-5.tar.gz";
    url = mirror://sourceforge/hol/hol/kananaskis-5/kananaskis-5.tar.gz;
    sha256 = "1qjfx5ii80v17yr04hz70n8aa46892fjc4qcxs9gs7nh3hw7rvmx";
  };

  buildInputs = [polyml];

  buildCommand = ''
    mkdir -p "$out/src"
    cd  "$out/src"

    tar -xzf "$src"
    cd hol

    substituteInPlace tools-poly/Holmake/Holmake.sml --replace \
      "\"/bin/mv\"" \
      "\"mv\""

    #sed -ie "/compute/,999 d" tools/build-sequence # for testing

    poly < tools/smart-configure.sml
    
    bin/build -expk -symlink

    mkdir -p "$out/bin"
    ln -st $out/bin  $out/src/hol/bin/*
    # ln -s $out/src/hol/bin $out/bin
  '';

  meta = {
    description = "HOL4, an interactive theorem prover based on Higher-Order Logic.";
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
