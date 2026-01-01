{
  lib,
  rustPlatform,
  fetchFromGitHub,
  replaceVars,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "lalrpop";
  version = "0.22.2";

  src = fetchFromGitHub {
    owner = "lalrpop";
    repo = "lalrpop";
    rev = version;
    hash = "sha256-/mk4sTgwxBrB+LEBbWv4OQEEh2P2KVSh6v5ry9/Et4s=";
  };

  cargoHash = "sha256-3Lm25X2QQQ4+3Spe6Nz5PkIvFcgwHQ+hqAdjsFesgro=";

  patches = [
    (replaceVars ./use-correct-binary-path-in-tests.patch {
      target_triple = stdenv.hostPlatform.rust.rustcTarget;
    })
  ];

  buildAndTestSubdir = "lalrpop";

  # there are some tests in lalrpop-test and some in lalrpop
  checkPhase = ''
    buildAndTestSubdir=lalrpop-test cargoCheckHook
    cargoCheckHook
  '';

<<<<<<< HEAD
  meta = {
    description = "LR(1) parser generator for Rust";
    homepage = "https://github.com/lalrpop/lalrpop";
    changelog = "https://github.com/lalrpop/lalrpop/blob/${src.rev}/RELEASES.md";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "LR(1) parser generator for Rust";
    homepage = "https://github.com/lalrpop/lalrpop";
    changelog = "https://github.com/lalrpop/lalrpop/blob/${src.rev}/RELEASES.md";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      asl20 # or
      mit
    ];
    mainProgram = "lalrpop";
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ chayleaf ];
=======
    maintainers = with maintainers; [ chayleaf ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
