{
  lib,
  rustPlatform,
  fetchFromGitHub,
  btfdump,
  rustc,
  # Override this if you are compiling your BPF programs with a version of
  # rustc that uses a different LLVM version, for example when using a rust
  # overlay.
  llvmPackagesForLinker ? rustc.llvmPackages,
  zlib,
  libxml2,
}:
rustPlatform.buildRustPackage rec {
  pname = "bpf-linker";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "aya-rs";
    repo = "bpf-linker";
    tag = "v${version}";
    hash = "sha256-y4jlEs9oF5jLlLkJHqXUMsHOeLUhTCDeqwnYzp8H9yI=";
  };

  cargoHash = "sha256-MSjwNgFa847R8joc8oreVpWDujsKR9duooycmlaiB0U=";

  buildNoDefaultFeatures = true;
  buildFeatures = [ "llvm-${lib.versions.major llvmPackagesForLinker.llvm.version}" ];

  buildInputs = [
    zlib
    libxml2
    (lib.getLib llvmPackagesForLinker.llvm)
  ];

  nativeCheckInputs = [
    btfdump
    llvmPackagesForLinker.clang.cc
    llvmPackagesForLinker.llvm
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
