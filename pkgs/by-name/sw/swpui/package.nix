{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swpui";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "swpui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9+j2PvV0GKiUutfNgQVEk7kQOB7Eb98K3aKPr3wORRE=";
  };

  cargoHash = "sha256-IZmZukBt2dlQST0Wsuqgqo+T3hPHIPzbu5OfNxnPSWk=";

  meta = {
    description = "TUI utility to search and replace with a focus on ergonomics, speed and case-awareness";
    homepage = "https://github.com/beeb/swpui";
    changelog = "https://github.com/beeb/swpui/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ beeb ];
    mainProgram = "swp";
  };
})
