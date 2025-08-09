{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gptscript";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "gptscript-ai";
    repo = "gptscript";
    tag = "v${version}";
    hash = "sha256-9wyDcvY5JCjtvx6XtvHwOsZLCiN1fRn0wBGaIaw2iRQ=";
  };

  vendorHash = "sha256-ajglXWGJhSJtcrbSBmxmriXFTT+Vb4xYq0Ec9SYRlQk=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gptscript-ai/gptscript/pkg/version.Tag=v${version}"
  ];

  # Requires network access
  doCheck = false;

  meta = {
    homepage = "https://github.com/gptscript-ai/gptscript";
    changelog = "https://github.com/gptscript-ai/gptscript/releases/tag/v${version}";
    description = "Build AI assistants that interact with your systems";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ jamiemagee ];
    mainProgram = "gptscript";
  };
}
