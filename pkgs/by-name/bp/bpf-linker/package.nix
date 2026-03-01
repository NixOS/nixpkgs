{
  lib,
  rustPlatform,
  fetchFromGitHub,
  btfdump,
  rustc,
  zlib,
  libxml2,
}:
rustPlatform.buildRustPackage rec {
  pname = "bpf-linker";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "aya-rs";
    repo = "bpf-linker";
    tag = "v${version}";
    hash = "sha256-jtTDjbE2F5uj9lSTO0CuOY0fXp5IZKKMJBgAStk0c48=";
  };

  cargoHash = "sha256-EPd99fRJaLT5xYsZTLb+c4a/vS91JRyOmTcgNC9x9fM=";

  buildNoDefaultFeatures = true;
  buildFeatures = [ "llvm-${lib.versions.major rustc.llvm.version}" ];

  buildInputs = [
    zlib
    libxml2
    (lib.getLib rustc.llvm)
  ];

  patches = [
    ./remove-sysroot-override.patch
    ./override-libllvm-location.patch
  ];

  env.LLVM_LIB_PATH = "${lib.getLib rustc.llvm}/lib";

  nativeCheckInputs = [
    btfdump
    rustc.llvmPackages.clang.cc
    rustc.llvm
  ];

  meta = {
    description = "Simple BPF static linker";
    mainProgram = "bpf-linker";
    homepage = "https://github.com/aya-rs/bpf-linker";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
