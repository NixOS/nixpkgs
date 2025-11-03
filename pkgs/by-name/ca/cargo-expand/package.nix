{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.118";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-expand";
    tag = version;
    hash = "sha256-+n4eiwcToXtWMPmvE41kOcZHzgugjekxQkodDagDjhI=";
  };

  cargoHash = "sha256-Di7Nnp8qYqpTkKmmUYoKxSkntepG80vVF2AkaN5yW+U=";

  meta = {
    description = "Cargo subcommand to show result of macro expansion";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      xrelkd
    ];
    mainProgram = "cargo-expand";
  };
}
