{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation {
  pname = "drat-trim";
  version = "2023-05-22";

  src = fetchFromGitHub {
    owner = "marijnheule";
    repo = "drat-trim";
    tag = "v05.22.2023";
    hash = "sha256-sV3A0f1TLSaTIdAtT6y8rU3ZS2UqEePJYSf3UySOlSA=";
  };

  patches = [
    # gcc-14 build fix: https://github.com/marijnheule/drat-trim/pull/40
    (fetchpatch {
      name = "gcc-14-fix.patch";
      url = "https://github.com/marijnheule/drat-trim/commit/8186a7dc083a3951ba87e5ff35d36f1ea2c03f0d.patch";
      hash = "sha256-jgsOYcRYD2VGdOrXW9D8Jh80Nqd+Kp3d2IU+bNK1yGg=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile --replace gcc cc
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin drat-trim lrat-check

    runHook postInstall
  '';

  meta = with lib; {
    description = "Proof checker for unSAT proofs";
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
