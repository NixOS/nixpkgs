{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  llvmPackages_19,
  libffi,
  zlib,
  libxml2,
}:

rustPlatform.buildRustPackage rec {
  pname = "qir-runner";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "qir-alliance";
    repo = "qir-runner";
    tag = "v${version}";
    hash = "sha256-k93I/DE8Jx0DbloBVNhKKay/L26H5TPX5yvkHKe/yBg=";
  };

  nativeBuildInputs = [ llvmPackages_19.llvm ];
  buildInputs = [
    libffi
    zlib
    libxml2
  ];

  cargoHash = "sha256-U/9oDOPhlSL1ViW1n5C4MWRvUvU4c/cuATLNIx7FkiM=";

  meta = {
    description = "QIR bytecode runner to assist with QIR development and validation";
    mainProgram = "qir-runner";
    homepage = "https://qir-alliance.github.io/qir-runner";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bbenno ];
    # llvm-sys crate locates llvm by calling llvm-config
    # which is not available when cross compiling
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
}
