{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "alioth";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "alioth";
    tag = "v${version}";
    hash = "sha256-7mQmyWOMEHg374mmYGJL8xhVWlYk1zKplpjc74wLoKw=";
  };

  # Checks use `debug_assert_eq!`
  checkType = "debug";

  useFetchCargoVendor = true;
  cargoHash = "sha256-rAq3Ghg7zpiycQ8hNzn4Jz7cUCfwQ4aqtWxoVCg8MrE=";

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
