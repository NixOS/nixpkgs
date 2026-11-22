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
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "aya-rs";
    repo = "bpf-linker";
    tag = "v${version}";
    hash = "sha256-7zyOEviraFND2/GdEi0J+BBmn8WgYdpDdwSFixszSUo=";
  };

  cargoHash = "sha256-VL1qGpXyZB/WOHqEx+G0nQrUAHRf2coWGvisR9ZoikQ=";

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
