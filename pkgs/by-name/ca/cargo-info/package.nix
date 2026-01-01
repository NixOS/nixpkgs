{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-info";
  version = "0.7.7";

  src = fetchFromGitLab {
    owner = "imp";
    repo = "cargo-info";
    tag = version;
    hash = "sha256-MrkYGUd1jsAqIVYWe7YDZaq7NPv/mHQqLS7GFrYYIo8=";
  };

  cargoHash = "sha256-C8BIgJeUPvFzf0LTBMZ3oyE0eWh5HH6aobhUAHBxxKU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Cargo subcommand to show crates info from crates.io";
    mainProgram = "cargo-info";
    homepage = "https://gitlab.com/imp/cargo-info";
    changelog = "https://gitlab.com/imp/cargo-info/-/blob/${src.rev}/CHANGELOG.md";
<<<<<<< HEAD
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
=======
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      matthiasbeyer
    ];
  };
}
