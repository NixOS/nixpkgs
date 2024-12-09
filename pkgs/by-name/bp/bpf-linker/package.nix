{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, llvmPackages_19
, zlib
, ncurses
, libxml2
}:

rustPlatform.buildRustPackage rec {
  pname = "bpf-linker";
  version = "0.9.13";

  src = fetchFromGitHub {
    owner = "aya-rs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-CRYp1ktmmY4OS23+LNKOBQJUMkd+GXptBp5LPfbyZAc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "compiletest_rs-0.10.2" = "sha256-JTfVfMW0bCbFjQxeAFu3Aex9QmGnx0wp6weGrNlQieA=";
    };
  };

  buildNoDefaultFeatures = true;

  nativeBuildInputs = [ llvmPackages_19.llvm ];
  buildInputs = [ zlib ncurses libxml2 ];

  # fails with: couldn't find crate `core` with expected target triple bpfel-unknown-none
  # rust-src and `-Z build-std=core` are required to properly run the tests
  doCheck = false;

  meta = with lib; {
    description = "Simple BPF static linker";
    mainProgram = "bpf-linker";
    homepage = "https://github.com/aya-rs/bpf-linker";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ nickcao ];
    # llvm-sys crate locates llvm by calling llvm-config
    # which is not available when cross compiling
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
}
