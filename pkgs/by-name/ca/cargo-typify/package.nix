{
  lib,
  rustfmt,
  rustPlatform,
  fetchFromGitHub,
  gitUpdater,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-typify";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = "typify";
    rev = "v${version}";
    hash = "sha256-Clwm5hRjPPPRB6xpO8YOGpqnyNFtsSMkPbWBY3etPCI=";
  };

  cargoHash = "sha256-balx5xOtrWwMOFeGQkYQ2f+lcGMCJvdPqE8rH9adkfU=";

  cargoBuildFlags = [
    "-p"
    "cargo-typify"
  ];

  nativeCheckInputs = [ rustfmt ];

  preCheck = ''
    # cargo-typify depends on rustfmt-wrapper, which requires RUSTFMT:
    export RUSTFMT="${lib.getExe rustfmt}"
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "JSON Schema to Rust type converter";
    mainProgram = "cargo-typify";
    homepage = "https://github.com/oxidecomputer/typify";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ david-r-cox ];
    broken = true;
  };
}
