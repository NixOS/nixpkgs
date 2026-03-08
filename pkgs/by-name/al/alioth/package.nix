{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alioth";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "alioth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VkyR9NOxv5PVuW172Sw2ign6sApDnKTnH2BBlVl6GFk=";
  };

  # Checks use `debug_assert_eq!`
  checkType = "debug";

  cargoHash = "sha256-NUbu2AL5gD7OOskNGO0pitJaTlgCYxAr6GYyv8nuytI=";

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
