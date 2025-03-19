{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  llvmPackages_20,
  zlib,
  ncurses,
  libxml2,
}:

rustPlatform.buildRustPackage rec {
  pname = "bpf-linker";
  version = "0.9.14";

  src = fetchFromGitHub {
    owner = "aya-rs";
    repo = "bpf-linker";
    tag = "v${version}";
    hash = "sha256-accW1w0Mn9Mo9r2LrupQdgx+3850Dth8EfnnuzO+ZzM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-D1N4zQjpllQg6Nn92+HWWsSmGsOon0mygErWg3X8Gx8=";

  buildNoDefaultFeatures = true;

  nativeBuildInputs = [ llvmPackages_20.llvm ];
  buildInputs = [
    zlib
    ncurses
    libxml2
  ];

  # fails with: couldn't find crate `core` with expected target triple bpfel-unknown-none
  # rust-src and `-Z build-std=core` are required to properly run the tests
  doCheck = false;

  meta = {
    description = "Simple BPF static linker";
    mainProgram = "bpf-linker";
    homepage = "https://github.com/aya-rs/bpf-linker";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ nickcao ];
    # llvm-sys crate locates llvm by calling llvm-config
    # which is not available when cross compiling
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
}
