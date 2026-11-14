{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lazymc";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "timvisee";
    repo = "lazymc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uMjM3w78qWnB/sNXRcxl30KJRm0I3BPEOr5IRU8FI0s=";
  };

  cargoHash = "sha256-jqqqWZKO1HgwxLBGMz9rlFQ5xmZTycfUZjqHf+uVTBQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Remote wake-up daemon for minecraft servers";
    homepage = "https://github.com/timvisee/lazymc";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      h7x4
      dandellion
    ];
    platforms = lib.platforms.unix;
    mainProgram = "lazymc";
  };
})
