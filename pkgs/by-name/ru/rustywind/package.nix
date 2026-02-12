{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustywind";
  version = "0.24.3";

  src = fetchFromGitHub {
    owner = "avencera";
    repo = "rustywind";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qbOlU7kqVbB/sQg4b78CohOwQbraulZ8dRxeT+39rFk=";
  };

  cargoHash = "sha256-eXTdPtcsWhsABZU6kRzZ6eF1VaabouZwLAFI9KpAx98=";

  meta = {
    description = "CLI for organizing Tailwind CSS classes";
    mainProgram = "rustywind";
    homepage = "https://github.com/avencera/rustywind";
    changelog = "https://github.com/avencera/rustywind/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
