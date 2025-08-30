{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  llvmPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ldk-node";
  version = "0-unstable-2025-08-21";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "ldk-node";
    rev = "078a26fb3a79f1ef66443b773018a1cf917cb5da";
    hash = "sha256-ZmeohMnIbJzJbo9U+t0AWKFqLSIzDL/G42cBSBCtj3Q=";
  };

  buildFeatures = [ "uniffi" ];

  cargoHash = "sha256-VLQohnbuEdnu2E+BXe2mDKFUnDVlSY09rIIvHMIQ+Hg=";

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
