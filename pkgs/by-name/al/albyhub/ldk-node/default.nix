{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  llvmPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ldk-node";
  version = "0-unstable-2025-07-18";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "ldk-node";
    rev = "7ada683f2edf05207caf88ba79ce2f857a9646c7";
    hash = "sha256-y4yU+sRuyFmspy0HA7qxfbrYG9FQw6HCKwSVNFEXA+I=";
  };

  buildFeatures = [ "uniffi" ];

  cargoHash = "sha256-hNiI14N2AlMOtU6HaXMBV7tVqdkVpA3NXZvHvpa1Kio=";

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
