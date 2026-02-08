{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "gptscript";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "gptscript-ai";
    repo = "gptscript";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fLpSuShRqQGK3WaiJBJqgF1fjJSmnNMqkiJ50H8kTJ4=";
  };

  vendorHash = "sha256-jctYQD8HZ/1VQyPtipZjk4OFszHGcEUqNHTRw+fkDKE=";

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
