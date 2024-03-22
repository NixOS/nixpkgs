{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, installShellFiles
}:

buildGoModule rec {
  pname = "glasskube";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "glasskube";
    repo = "glasskube";
    rev = "refs/tags/v${version}";
    hash = "sha256-iJjO4V2sK3e/SpDZ5Lfw7gILgZrI4CGg0wLLVKthGUE=";
  };

  vendorHash = "sha256-iFWcTzZP0DKJ9hrmfUWR4U/VX2zsR+3uojI+GRI2R3I=";

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" "-X github.com/glasskube/glasskube/internal/config.Version=${version}" "-X github.com/glasskube/glasskube/internal/config.Commit=${src.rev}" ];

  subPackages = [ "cmd/${pname}" "cmd/package-operator" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    # Completions
    installShellCompletion --cmd glasskube \
      --bash <($out/bin/glasskube completion bash) \
      --fish <($out/bin/glasskube completion fish) \
      --zsh <($out/bin/glasskube completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "The missing Package Manager for Kubernetes featuring a GUI and a CLI";
    homepage = "https://github.com/glasskube/glasskube";
    changelog = "https://github.com/glasskube/glasskube/releases/tag/v${version}";
    maintainers = with maintainers; [ jakuzure ];
    license = licenses.asl20;
    mainProgram = "glasskube";
  };
}
