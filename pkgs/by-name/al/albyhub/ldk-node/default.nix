{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  llvmPackages,
}:

rustPlatform.buildRustPackage rec {
  pname = "ldk-node";
  version = "v0.0.0-20250521132529-9bb381ad38db";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "ldk-node";
    rev = "v0.0.0-20250521132529-9bb381ad38db";
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
  ];

  # Set LIBCLANG_PATH to help bindgen find libclang
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # Add CFLAGS to suppress the stringop-overflow error during aws-lc-sys compilation.
  NIX_CFLAGS_COMPILE = "-Wno-error=stringop-overflow";

  meta = {
    description = "Embeds the LDK node implementation compiled as shared library objects";
    homepage = "https://github.com/getAlby/ldk-node";
    changelog = "https://github.com/getAlby/ldk-node/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ bleetube ];
  };
}
