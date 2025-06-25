{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "coldsnap";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "coldsnap";
    rev = "v${version}";
    hash = "sha256-tlQ4PDrYnnbsxXRbrIoF08aSy7VP+iXgTKf0A8MITpo=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-Z4UbMdu35m/myiqrFFpvlmVfCD0MlSTQRvs2uhnxBAI=";

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
