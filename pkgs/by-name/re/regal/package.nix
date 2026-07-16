{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "regal";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "regal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-52kYnkOEhNk491vaoCSgR47frmN/mFCKyHqWnIBcEE8=";
  };

  vendorHash = "sha256-Vl6u/dwtG8RBpSQUrS5rAQ0Hag2R5X6rVQe9PHb/4U8=";

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
