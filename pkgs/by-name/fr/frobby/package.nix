{
  lib,
  stdenv,
  fetchFromGitHub,

  gmp,
}:
let
  version = "0.9.7";
in
stdenv.mkDerivation {
  pname = "frobby";
  version = version;

  src = fetchFromGitHub {
    owner = "Macaulay2";
    repo = "frobby";
    rev = "08ee1fda0974a30be116a4b9b3ef75f5c422e913";
    hash = "sha256-wFsD03+j530PYueVN2sxBs8AyMZU47vLs6ytN6HyO2I";
  };

  buildInputs = [
    gmp
  ];

  __structuredAttrs = true;

  strictDeps = true;

  postPatch = ''
    patchShebangs --build .
  '';

  enableParallelBuilding = true;

  buildFlags = [
    "all"
    "library"
    "MODE=shared"
  ];

  checkPhase = "test/runTests";

  installFlags = [
    "PREFIX=$(out)"
    "BIN_INSTALL_DIR=$(out)/bin"
  ];

  meta = {
    description = "Software system and project for computations with monomial ideals";
    longDescription = ''
      Current functionality includes Euler characteristic, Hilbert series,
      maximal standard monomials, combinatorial optimization on monomial
      ideals, primary decomposition, irreducible decomposition, Alexander dual,
      associated primes, minimization and intersection of monomial ideals as
      well as the computation of Frobenius problems (using 4ti2) with very
      large numbers. Frobby is also able to translate between formats that can
      be used with several different computer systems, such as Macaulay2,
      Monos, 4ti2, CoCoA4 and Singular. Thus Frobby can be used with any of
      those systems.
    '';
    homepage = "https://github.com/Macaulay2/frobby";
    license = lib.licenses.gpl2Plus;
  };
}
