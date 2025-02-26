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
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "qir-alliance";
    repo = "qir-runner";
    tag = "v${version}";
    hash = "sha256-65ioZ+7Xo4ocpFFVvwtY6Hn1FKuI48hcAfbAjPnSYEs=";
  };

  nativeBuildInputs = [ llvmPackages_19.llvm ];
  buildInputs = [
    libffi
    zlib
    libxml2
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-ciQ6TFl+LNBVrIwhCdpzbaQz72W7EC5wj85PW29UV0M=";

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
