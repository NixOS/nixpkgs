{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  llvmPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ldk-node";
  version = "0-unstable-2025-05-21";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "ldk-node";
    rev = "9bb381ad38dbaa71e17816738789d993158fc1a2";
    hash = "sha256-Ie7FOSOd12mwmkEjD4r0p1ZmeYkXm5eN1LlQhWl0VG4=";
  };

  buildFeatures = [ "uniffi" ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-hM6VCU0kIg5ZmJM8C4HoybSc/VXNj6GTE/oFLfqGMcY=";

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
