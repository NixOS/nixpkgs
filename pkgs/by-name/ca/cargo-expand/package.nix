{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.91";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    hash = "sha256-ucxqC5OqBqmM9+jKnGWLd9g2GDAXjAqSl+0ouhs6evA=";
  };

  cargoHash = "sha256-vDYpFJ+RFjouXgZc+ESPpkXA4sv5eHVZc93s+3KJj2g=";

  meta = with lib; {
    description = "Cargo subcommand to show result of macro expansion";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      xrelkd
    ];
    mainProgram = "cargo-expand";
  };
}
