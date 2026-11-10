# These tests show that the minizinc build is capable of running the
# examples in the official tutorial:
# https://www.minizinc.org/doc-2.7.3/en/modelling.html

{ stdenv, minizinc }:

stdenv.mkDerivation {
  name = "minizinc-simple-test";

  nativeBuildInputs = [ minizinc ];

  dontInstall = true;

  buildCommand = ''
    mkdir -p $out
    minizinc --solver gecode ${./aust.mzn} | tee $out/aust.log
    minizinc --solver gecode ${./nqueens.mzn} | tee $out/nqueens.log
    minizinc --solver cbc ${./loan.mzn} ${./loan1.dzn} | tee $out/loan.log
  '';

  meta.timeout = 10;
}
