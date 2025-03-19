{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustypaste-cli";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "rustypaste-cli";
    rev = "v${version}";
    hash = "sha256-ziIY/dz/2nwv0S6gUbVsrTXTNkGLh9MRNXnhhVOnCvA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-R6mdHoARtnIRpN18KF1TVIgBzEtCinb0xfCM3nz2sxk=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "CLI tool for rustypaste";
    homepage = "https://github.com/orhun/rustypaste-cli";
    changelog = "https://github.com/orhun/rustypaste-cli/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rpaste";
  };
}
