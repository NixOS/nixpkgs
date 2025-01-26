{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustywind";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "avencera";
    repo = "rustywind";
    rev = "v${version}";
    hash = "sha256-4VpSf6ukeDbz8pRxsDt38MxMDgavAOqgzIof/3AaJ04=";
  };

  cargoHash = "sha256-hV0dKFuDDJQLRe/eFBDpPEetwJXnElLVE8kzjiQ5Itk=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "CLI for organizing Tailwind CSS classes";
    mainProgram = "rustywind";
    homepage = "https://github.com/avencera/rustywind";
    changelog = "https://github.com/avencera/rustywind/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
