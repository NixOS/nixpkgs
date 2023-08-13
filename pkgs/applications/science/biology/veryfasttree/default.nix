{ lib
, stdenv
, fetchFromGitHub
, cmake
, llvmPackages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "veryfasttree";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "citiususc";
    repo = "veryfasttree";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JMBhSxfGO3qz7Yl4s5r6zWHFefXGzu0ktEJdRUh/Uqg=";
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
