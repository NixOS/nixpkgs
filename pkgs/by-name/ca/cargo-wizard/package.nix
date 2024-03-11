{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-wizard";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "kobzol";
    repo = "cargo-wizard";
    rev = "v${version}";
    hash = "sha256-b8PFJphnTTzW0+f6p59CvQeZMnK6Szp0l/666guDbuc=";
  };

  cargoHash = "sha256-qBqFnvmGKZQv0vWigsUKELDNqy245GqBm3Nif2hAa78=";

  preCheck = ''
    export PATH=$PATH:$PWD/target/${stdenv.hostPlatform.rust.rustcTarget}/$cargoBuildType
  '';

  meta = with lib; {
    description = "Cargo subcommand for configuring Cargo profile for best performance";
    homepage = "https://github.com/kobzol/cargo-wizard";
    changelog = "https://github.com/kobzol/cargo-wizard/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
    mainProgram = "cargo-wizard";
  };
}
