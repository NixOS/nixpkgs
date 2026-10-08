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
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "qir-alliance";
    repo = "qir-runner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G8jIO5MC0VJu0hAUVV0/YgOdP8G3qNiRB9m6YIDkutg=";
  };

  nativeBuildInputs = [ llvmPackages_20.llvm.dev ];
  buildInputs = [
    libffi
    zlib
    libxml2
    llvmPackages_20.llvm
  ];

  cargoHash = "sha256-5hPgDUhPiIrsnGl/HjYJYp/5Ih/2dHg4B+DJ4Ho3uUs=";

  meta = {
    description = "QIR bytecode runner to assist with QIR development and validation";
    mainProgram = "qir-runner";
    homepage = "https://qir-alliance.github.io/qir-runner";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bbenno ];
  };
})
