{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "alioth";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "alioth";
    tag = "v${version}";
    hash = "sha256-6+Co+Du08Hr2U8vifsD5kYfgSERVkFZ2BpqE1wXEDkM=";
  };

  # Checks use `debug_assert_eq!`
  checkType = "debug";

  cargoHash = "sha256-W01mqG0QlKDP/b4NbVm/ohySF3v5j38BLZEuMwkFffs=";

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
