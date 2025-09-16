{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  btfdump,
  rustc,
  zlib,
  libxml2,
}:

rustPlatform.buildRustPackage rec {
  pname = "bpf-linker";
  version = "0.9.15";

  src = fetchFromGitHub {
    owner = "aya-rs";
    repo = "bpf-linker";
    tag = "v${version}";
    hash = "sha256-5HXYtAn6KaFXsiA3Nt0IwmFLOXBhZWYrD8cMZ8rZ1fk=";
  };

  cargoHash = "sha256-coIcd6WjVQM/b51jwkG8It/wubXx6wuuPlzzelPFE38=";

  buildNoDefaultFeatures = true;
  buildFeatures = [ "llvm-${lib.versions.major rustc.llvm.version}" ];

  nativeBuildInputs = [ rustc.llvm ];

  buildInputs = [
    zlib
    libxml2
  ];

  nativeCheckInputs = [
    btfdump
    rustc.llvmPackages.clang.cc
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
    # llvm-sys crate locates llvm by calling llvm-config
    # which is not available when cross compiling
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
}
