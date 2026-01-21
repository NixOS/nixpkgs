{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nkeys";
  version = "0.4.12";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nkeys";
    tag = "v${version}";
    hash = "sha256-uNvRzljA6c6ppFtZLpFmwz/c9fmDzQz44Ekys0rBZ+o=";
  };

  vendorHash = "sha256-yZc2qG61VsUDXr1uxF/BK7WFI6a7xOsjAxnw6G+JpeQ=";

  meta = {
    description = "Public-key signature system for NATS";
    homepage = "https://github.com/nats-io/nkeys";
    changelog = "https://github.com/nats-io/nkeys/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nk";
  };
}
