{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustywind";
  version = "0.24.3";

  src = fetchFromGitHub {
    owner = "avencera";
    repo = "rustywind";
    rev = "v${version}";
    hash = "sha256-qbOlU7kqVbB/sQg4b78CohOwQbraulZ8dRxeT+39rFk=";
  };

  cargoHash = "sha256-eXTdPtcsWhsABZU6kRzZ6eF1VaabouZwLAFI9KpAx98=";

  meta = with lib; {
    description = "CLI for organizing Tailwind CSS classes";
    mainProgram = "rustywind";
    homepage = "https://github.com/avencera/rustywind";
    changelog = "https://github.com/avencera/rustywind/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
