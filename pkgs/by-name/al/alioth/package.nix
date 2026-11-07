{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alioth";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "alioth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ny/YrXHo4qP8NDiRNtXv843RjJKzKFuSH20ZoGp3ODQ=";
  };

  # Checks use `debug_assert_eq!`
  checkType = "debug";

  cargoHash = "sha256-eWozwXaVtR/3k7w7+tPzK1xlt9/DtvTYC+YPL/A+sU0=";

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
})
