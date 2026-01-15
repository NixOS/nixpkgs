{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  name = "regal";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "regal";
    rev = "v${version}";
    hash = "sha256-zAp4v1bKz+q+29jlhEccl7o9RWLA+Hn3Kp/UGBQlmA8=";
  };

  vendorHash = "sha256-yvUvv8EL3WrsyBnzaGQK4DR+O5Ner9ehkZYCMnfRwRU=";

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
