{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "alioth";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "alioth";
    tag = "v${version}";
    hash = "sha256-lR3TrGCjOp+NprAXUttLWSEi2LDGCOpW9Bg5TH7reys=";
  };

  # Checks use `debug_assert_eq!`
  checkType = "debug";

  cargoHash = "sha256-lZam3/GuKIoGdWFhOc8E54yHVr0ah39HGiMVmNwCDlI=";

  separateDebugInfo = true;

  meta = {
    homepage = "https://github.com/google/alioth";
    description = "Experimental Type-2 Hypervisor in Rust implemented from scratch";
    license = lib.licenses.asl20;
    mainProgram = "alioth";
    maintainers = with lib.maintainers; [ astro ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
