{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "drat-trim-unstable";
  version = "2020-06-05";

  src = fetchFromGitHub {
    owner = "marijnheule";
    repo = "drat-trim";
    rev = "9afad0f7156a1e9c6ce19dce5d72cf1cb9a3ef27";
    sha256 = "1zq585igfaknwqbvv2cji744016zxadbvr0ifr5l6yq13m0vvn3b";
  };

  postPatch = ''
    substituteInPlace Makefile --replace gcc cc
  '';

  installPhase = ''
    install -Dt $out/bin drat-trim lrat-check
  '';

  meta = with lib; {
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

      This package also contains the related tool LRAT-check, which checks a
      proof format called LRAT which extends DRAT with hint statements to speed
      up the checking process.
    '';
    homepage = "https://www.cs.utexas.edu/~marijn/drat-trim/";
    license = licenses.mit;
    maintainers = with maintainers; [ kini ];
    platforms = platforms.all;
  };
}
