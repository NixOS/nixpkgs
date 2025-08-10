{
  lib,
  rustPlatform,
  fetchFromGitHub,
  replaceVars,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "lalrpop";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "lalrpop";
    repo = "lalrpop";
    rev = version;
    hash = "sha256-RvKJ3PKOKJbY0/WBpUwbau9LyCzb/peD73Ey9stECeg=";
  };

  cargoHash = "sha256-KqG8AqYK1sslZyqCMKesxuyy9+IenXW56edoxygKj4k=";

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

  meta = with lib; {
    description = "LR(1) parser generator for Rust";
    homepage = "https://github.com/lalrpop/lalrpop";
    changelog = "https://github.com/lalrpop/lalrpop/blob/${src.rev}/RELEASES.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    mainProgram = "lalrpop";
    maintainers = with maintainers; [ chayleaf ];
  };
}
