{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, installShellFiles
}:

buildGoModule rec {
  pname = "glasskube";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "glasskube";
    repo = "glasskube";
    rev = "refs/tags/v${version}";
    hash = "sha256-+5SinF85bU113C9B025DM83v8ApaXqLV4n1P9zZP3ns=";
  };

  vendorHash = "sha256-DBqO2EyB1TydsdK2GWJoFGGgTS+E62GogysPX4WtzYU=";

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
