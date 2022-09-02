{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "arkade";
  version = "0.8.39";

  src = fetchFromGitHub {
    owner = "alexellis";
    repo = "arkade";
    rev = version;
    sha256 = "sha256-ucM4Dl4ZeeZ6pCQ3qdf3Z88CWJIoreZWeo6ehKqXxI8=";
  };

  CGO_ENABLED = 0;

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = "sha256-TUaCqHbPEwhB2xS8RSoF7RCSkKFJzQKbuV1PbxApyMQ=";

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
