{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "alioth";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "alioth";
    tag = "v${version}";
    hash = "sha256-CQYh/F7eGk94dsXP7j3udhhBReYBvV6D8nzK/3VicwU=";
  };

  # Checks use `debug_assert_eq!`
  checkType = "debug";

  useFetchCargoVendor = true;
  cargoHash = "sha256-kW76EBlpzeSmIhW5UsYjPYp5KeH2mPuf3aAiTSM06g4=";

  separateDebugInfo = true;

  meta = with lib; {
    homepage = "https://github.com/google/alioth";
    description = "Experimental Type-2 Hypervisor in Rust implemented from scratch";
    license = licenses.asl20;
    mainProgram = "alioth";
    maintainers = with maintainers; [ astro ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
