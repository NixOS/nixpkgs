{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  name = "regal";
  version = "0.38.1";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "regal";
    rev = "v${version}";
    hash = "sha256-/WGZCwT9VJ5zjEmL4PZqPymaUJFaWzjbgq2KMBfl6uQ=";
  };

  vendorHash = "sha256-b7Q9eqq/lDykIQ0tkwBWk2ukAoScBTApfwoE2Ubm5iQ=";

  # Only build the main binary, exclude build/lsp/main.go
  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/open-policy-agent/regal/pkg/version.Version=${version}"
    "-X github.com/open-policy-agent/regal/pkg/version.Commit=${version}"
  ];

  meta = {
    description = "Linter and language server for Rego";
    mainProgram = "regal";
    homepage = "https://github.com/open-policy-agent/regal";
    changelog = "https://github.com/open-policy-agent/regal/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rinx ];
  };
}
