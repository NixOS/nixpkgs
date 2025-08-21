{
  lib,
  fetchFromGitHub,
  gitUpdater,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-docset";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Robzz";
    repo = "cargo-docset";
    rev = "v${version}";
    hash = "sha256-o2CSQiU9fEoS3eRmwphtYGZTwn3mstRm2Tlvval83+U=";
  };

  cargoHash = "sha256-MHSvrZXh9RLuiLEc4IHPvtIKjdRjFhtmumPs4EuJtz0=";

  buildInputs = [ sqlite ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Cargo subcommand to generate a Dash/Zeal docset for your Rust packages";
    mainProgram = "cargo-docset";
    homepage = "https://github.com/Robzz/cargo-docset";
    changelog = "https://github.com/Robzz/cargo-docset/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      colinsane
      matthiasbeyer
    ];
  };
}
