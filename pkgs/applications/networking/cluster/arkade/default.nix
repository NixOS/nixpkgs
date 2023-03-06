{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "arkade";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "alexellis";
    repo = "arkade";
    rev = version;
    sha256 = "sha256-UEtKjZgVaNW6GyCId9D/61mmd79IxV4kPQXbyDpDU1Y=";
  };

  CGO_ENABLED = 0;

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-9QQuFrICfYLkoObNFsIn3H6brcv3qXL3FIguQMZ02HY=";

  # Exclude pkg/get: tests downloading of binaries which fail when sandbox=true
  subPackages = [
    "."
    "cmd"
    "pkg/apps"
    "pkg/archive"
    "pkg/config"
    "pkg/env"
    "pkg/helm"
    "pkg/k8s"
    "pkg/types"
  ];

  ldflags = [
    "-s" "-w"
    "-X github.com/alexellis/arkade/cmd.GitCommit=ref/tags/${version}"
    "-X github.com/alexellis/arkade/cmd.Version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd arkade \
      --bash <($out/bin/arkade completion bash) \
      --zsh <($out/bin/arkade completion zsh) \
      --fish <($out/bin/arkade completion fish)
  '';

  meta = with lib; {
    homepage = "https://github.com/alexellis/arkade";
    description = "Open Source Kubernetes Marketplace";
    license = licenses.mit;
    maintainers = with maintainers; [ welteki techknowlogick ];
  };
}
