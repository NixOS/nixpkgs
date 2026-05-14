{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "gptscript";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "gptscript-ai";
    repo = "gptscript";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gwSi+84SmLBxeRyZZS6qlSdiA8gZUj4h2LnU6oXmfdI=";
  };

  vendorHash = "sha256-C9dksQ7Js3omL8RWdQt6cEEGbGHnkXdgpYou2oKNm0Y=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gptscript-ai/gptscript/pkg/version.Tag=v${finalAttrs.version}"
  ];

  # Requires network access
  doCheck = false;

  meta = {
    homepage = "https://github.com/gptscript-ai/gptscript";
    changelog = "https://github.com/gptscript-ai/gptscript/releases/tag/v${finalAttrs.version}";
    description = "Build AI assistants that interact with your systems";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ jamiemagee ];
    mainProgram = "gptscript";
  };
})
