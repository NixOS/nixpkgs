<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, cmake
, llvmPackages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "veryfasttree";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "citiususc";
    repo = "veryfasttree";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Sp331VJRaYv/BTwFj3HwUcUsWjYf6YEXWjYdOzDhBBA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optional stdenv.cc.isClang llvmPackages.openmp;

  installPhase = ''
    runHook preInstall

    install -m755 -D VeryFastTree $out/bin/VeryFastTree

    runHook postInstall
  '';

  meta = {
    description = "Speeding up the estimation of phylogenetic trees for large alignments through parallelization and vectorization strategies";
    homepage = "https://github.com/citiususc/veryfasttree";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ thyol ];
    platforms = lib.platforms.all;
  };
})
=======
{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname   = "veryfasttree";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "citiususc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AOzbxUnrn1qgscjdOKf4dordnSKtIg3nSVaYWK1jbuc=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    install -m755 -D VeryFastTree $out/bin/VeryFastTree
  '';

  meta = with lib; {
    description = "Speeding up the estimation of phylogenetic trees for large alignments through parallelization and vectorization strategies";
    license     = licenses.gpl3Plus;
    homepage    = "https://github.com/citiususc/veryfasttree";
    maintainers = with maintainers; [ thyol ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
