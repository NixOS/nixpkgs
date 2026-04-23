{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  llvmPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ldk-node";
  version = "0-unstable-2026-02-10";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "ldk-node";
    rev = "3996cf18b10545f54c377212e155bb6bd664888e";
    hash = "sha256-mjIs7CeTRQ7Xuk9V/6LeXMDRZsd/wljeFHZ2vgEe1hg=";
  };

  buildFeatures = [ "uniffi" ];

  cargoHash = "sha256-30eLUzxBiGwQqWOD8MR9eOG8LWM5T8eTQuMTK3bjmV8=";

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
