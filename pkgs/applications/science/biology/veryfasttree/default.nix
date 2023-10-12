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
