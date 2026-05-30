{
  lib,
  buildGoModule,
  fetchFromGitHub,
  kustomize-lint,
  testers,
}:

buildGoModule rec {
  pname = "kustomize-lint";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "groq";
    repo = "kustomize-lint";
    tag = "v${version}";
    hash = "sha256-zVtF66A7w0RtEzZ9MNA4dqgxQUtpiUqcmnjslm4NxaE=";
  };

  vendorHash = "sha256-hCj3fmtt2lyD9ieGVPI1UXY1eDwBXEywOumzGJ+trXE=";

  subPackages = [ "cmd/kustomize-lint" ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = kustomize-lint;
    command = "kustomize-lint --version";
  };

  meta = {
    description = "Linter for Kustomize configuration files";
    homepage = "https://github.com/groq/kustomize-lint";
    changelog = "https://github.com/groq/kustomize-lint/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matanyall ];
    mainProgram = "kustomize-lint";
  };
}
