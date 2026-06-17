{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "regal";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "regal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iPbAlX/Mug4BT/Yn2h2XSpdOkkr8Mu2Th+8V005jzKs=";
  };

  vendorHash = "sha256-I+PmSyBe/j16yH1WaPFY/Ko6YRrwzpYeNKFesTp5t+Y=";

  # Only build the main binary, exclude build/lsp/main.go
  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/open-policy-agent/regal/pkg/version.Version=${finalAttrs.version}"
    "-X github.com/open-policy-agent/regal/pkg/version.Commit=${finalAttrs.version}"
  ];

  meta = {
    description = "Linter and language server for Rego";
    mainProgram = "regal";
    homepage = "https://github.com/open-policy-agent/regal";
    changelog = "https://github.com/open-policy-agent/regal/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rinx ];
  };
})
