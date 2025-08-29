{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "coldsnap";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "coldsnap";
    rev = "v${version}";
    hash = "sha256-ZN+gSoWrmGmN1jYxKLO06hRVyTM5WUXRjsfkcKcdXfM=";
  };

  cargoHash = "sha256-ZWJa/J5sfBA/F28TkXyspygN1ZkNz2TIEKTsusN4SOc=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    homepage = "https://github.com/awslabs/coldsnap";
    description = "Command line interface for Amazon EBS snapshots";
    changelog = "https://github.com/awslabs/coldsnap/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    teams = [ teams.determinatesystems ];
    mainProgram = "coldsnap";
  };
}
