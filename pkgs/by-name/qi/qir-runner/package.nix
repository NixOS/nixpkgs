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
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "qir-alliance";
    repo = "qir-runner";
    tag = "v${version}";
    hash = "sha256-KskBPvRlTw4ITuoAXyY+CyFfgTW0RtbLWDa97ftFOTA=";
  };

  nativeBuildInputs = [ llvmPackages_19.llvm ];
  buildInputs = [
    libffi
    zlib
    libxml2
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-3Ww5PEvk1CqiJTqEUdinmcAfcHLQjctrlM4F3BPBWQw=";

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
