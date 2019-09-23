{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "drat-trim-2017-08-31";

  src = fetchFromGitHub {
    owner = "marijnheule";
    repo = "drat-trim";
    rev = "37ac8f874826ffa3500a00698910e137498defac";
    sha256 = "1m9q47dfnvdli1z3kb1jvvbm0dgaw725k1aw6h9w00bggqb91bqh";
  };

  postPatch = ''
    substituteInPlace Makefile --replace gcc cc
  '';

  installPhase = ''
    install -Dt $out/bin drat-trim
  '';

  meta = with stdenv.lib; {
    description = "A proof checker for unSAT proofs";
    longDescription = ''
      DRAT-trim is a satisfiability proof checking and trimming
      utility designed to validate proofs for all known satisfiability
      solving and preprocessing techniques.  DRAT-trim can also emit
      trimmed formulas, optimized proofs, and TraceCheck+ dependency
      graphs.

      DRAT-trim has been used as part of the judging process in the
      annual SAT Competition in recent years, in order to check
      competing SAT solvers' work when they claim that a SAT instance
      is unsatisfiable.
    '';
    homepage = https://www.cs.utexas.edu/~marijn/drat-trim/;
    license = licenses.mit;
    maintainers = with maintainers; [ kini ];
    platforms = platforms.all;
  };
}
