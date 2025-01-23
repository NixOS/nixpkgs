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
    repo = pname;
    rev = "v${version}";
    hash = "sha256-o2CSQiU9fEoS3eRmwphtYGZTwn3mstRm2Tlvval83+U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-MHSvrZXh9RLuiLEc4IHPvtIKjdRjFhtmumPs4EuJtz0=";

  buildInputs = [ sqlite ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Cargo subcommand to generate a Dash/Zeal docset for your Rust packages";
    mainProgram = "cargo-docset";
    homepage = "https://github.com/Robzz/cargo-docset";
    changelog = "https://github.com/Robzz/cargo-docset/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      colinsane
      matthiasbeyer
    ];
  };
}
