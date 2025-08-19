{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  llvmPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ldk-node";
  version = "0-unstable-2025-06-30";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "ldk-node";
    rev = "b00326e36445312a55f9fb583a8b54cc5763b6bf";
    hash = "sha256-SDuHM7aawLXGSUxsKMlU0iH5+xs35VULX4vDGkS6xMA=";
  };

  buildFeatures = [ "uniffi" ];

  cargoHash = "sha256-ONlN5xMU4A7ZTF4+XRbs5qAv8xQVYuMsU0bnD8Eh2gE=";

  # Skip tests because they download bitcoin-core and electrs zip files, and then fail
  doCheck = false;

  nativeBuildInputs = [
    cmake
    llvmPackages.clang
    rustPlatform.bindgenHook
  ];

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
