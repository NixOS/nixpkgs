# Lambda Lisp has several backends, here we are using
# the blc one. Ideally, this should be made into several
# packages such as lambda-lisp-blc, lambda-lisp-lazyk,
# lambda-lisp-clamb, etc.

{
  lib,
  gccStdenv,
  fetchFromGitHub,
  fetchurl,
  runtimeShell,
}:

let
  stdenv = gccStdenv;
  s = import ./sources.nix { inherit fetchurl fetchFromGitHub; };
in
stdenv.mkDerivation rec {
  pname = "lambda-lisp-blc";
  version = s.lambdaLispVersion;
  src = s.src;
  flatSrc = s.flatSrc;
  blcSrc = s.blcSrc;

  installPhase = ''
    runHook preInstall

    mkdir -p ./build
    cp $blcSrc ./build/Blc.S
    cp $flatSrc ./build/flat.lds
    cd build;
    cat Blc.S | sed -e 's/#define.*TERMS.*//' > Blc.ext.S;
    $CC -c -DTERMS=50000000 -o Blc.o Blc.ext.S
    ld.bfd -o Blc Blc.o -T flat.lds
    cd ..;
    mv build/Blc ./bin
    install -D -t $out/bin bin/Blc
    install -D -t $out/lib bin/lambdalisp.blc

    cd build;
    $CC ../tools/asc2bin.c -O2 -o asc2bin;
    cd ..;
    mv build/asc2bin ./bin;
    chmod 755 ./bin/asc2bin;
    install -D -t $out/bin bin/asc2bin

    echo -e "#!${runtimeShell}\n( cat $out/lib/lambdalisp.blc | $out/bin/asc2bin; cat ) | $out/bin/Blc" > lambda-lisp-blc
    chmod +x lambda-lisp-blc

    install -D -t $out/bin lambda-lisp-blc
    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    a=$(echo "(* (+ 1 2 3 4 5 6 7 8 9 10) 12020569 (- 2 5))" | $out/bin/lambda-lisp-blc | tr -d "> ");
    test $a == -1983393885

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Lisp interpreter written in untyped lambda calculus";
    homepage = "https://github.com/woodrush/lambdalisp";
    longDescription = ''
      LambdaLisp is a Lisp interpreter written as a closed untyped lambda calculus term.
      It is written as a lambda calculus term LambdaLisp = λx. ... which takes a string
      x as an input and returns a string as an output. The input x is the Lisp program
      and the user's standard input, and the output is the standard output. Characters
      are encoded into lambda term representations of natural numbers using the Church
      encoding, and strings are encoded as a list of characters with lists expressed as
      lambdas in the Mogensen-Scott encoding, so the entire computation process solely
      consists of the beta-reduction of lambda terms, without introducing any
      non-lambda-type object.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ cafkafk ];
    platforms = [ "x86_64-linux" ];
  };
}
