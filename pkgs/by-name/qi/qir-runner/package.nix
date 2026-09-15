{
  lib,
  fetchFromGitHub,
  rustPlatform,
  llvmPackages_20,
  libffi,
  zlib,
  libxml2,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qir-runner";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "qir-alliance";
    repo = "qir-runner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5RfcHlJvdRjWfG6RbvIeCoMuos7O3Avu44uGcuOcz90=";
  };

  nativeBuildInputs = [ llvmPackages_20.llvm.dev ];
  buildInputs = [
    libffi
    zlib
    libxml2
    llvmPackages_20.llvm
  ];

  cargoHash = "sha256-0CLYpdfu9T6db6tarDF7i5dkIXjSzsmvtN+yuqZvB6s=";

  meta = {
    description = "QIR bytecode runner to assist with QIR development and validation";
    mainProgram = "qir-runner";
    homepage = "https://qir-alliance.github.io/qir-runner";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bbenno ];
  };
})
