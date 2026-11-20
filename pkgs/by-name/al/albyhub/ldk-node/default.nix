{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ldk-node";
  version = "0-unstable-2026-11-18";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "ldk-node";
    rev = "561ba34f72fcedd2bc063752a1328a5bbebc004b";
    hash = "sha256-D9RITOsbXJYjUBpERbzdpUEbRfQFop0zr1SgxDbsjIY=";
  };

  buildFeatures = [ "uniffi" ];

  cargoHash = "sha256-EaBwhEicEI1rqQGT3PmRLM8yj3/nAInx2SYv9ovETKc=";

  # Skip tests because they download bitcoin-core and electrs zip files, and then fail
  doCheck = false;

  nativeBuildInputs = [
    cmake
    llvmPackages.clang
    rustPlatform.bindgenHook
  ];

  buildInputs = [ sqlite ];

  # Add CFLAGS to suppress the stringop-overflow error during aws-lc-sys compilation.
  NIX_CFLAGS_COMPILE = "-Wno-error=stringop-overflow";

  meta = {
    description = "Embeds the LDK node implementation compiled as shared library objects";
    homepage = "https://github.com/getAlby/ldk-node";
    changelog = "https://github.com/getAlby/ldk-node/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bleetube ];
  };
})
