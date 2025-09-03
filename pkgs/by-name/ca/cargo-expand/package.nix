{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.114";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-expand";
    rev = version;
    hash = "sha256-blq/5ObzHxYjNx0TPiuF1OuDPHNDBV7jBkt1r+ISnVE=";
  };

  cargoHash = "sha256-HNmmu9TF7p94bRF/IsStIE5XPdcUM6d505G+wbFNTls=";

  meta = {
    description = "Cargo subcommand to show result of macro expansion";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      figsoda
      xrelkd
    ];
    mainProgram = "cargo-expand";
  };
}
