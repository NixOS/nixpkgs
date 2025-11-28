{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gptscript";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "gptscript-ai";
    repo = "gptscript";
    tag = "v${version}";
    hash = "sha256-eZvNW3VKhqgOOkkIFFHeWXowgxLV/05iQtR0XgH8Ghw=";
  };

  vendorHash = "sha256-BUOIIXFfd8p8tXH2tNLM897j5CkI2EqNU3V8pojrxFI=";

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
