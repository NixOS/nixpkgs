{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, kyverno }:

buildGoModule rec {
  pname = "kyverno";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "kyverno";
    repo = "kyverno";
    rev = "v${version}";
    sha256 = "sha256-Lx+ae0Eb8iVKurXpsb3NPTFrh59vxxf4fA18o1JTIv0=";
  };

  ldflags = [
    "-s" "-w"
    "-X github.com/kyverno/kyverno/pkg/version.BuildVersion=v${version}"
    "-X github.com/kyverno/kyverno/pkg/version.BuildHash=${version}"
    "-X github.com/kyverno/kyverno/pkg/version.BuildTime=1970-01-01_00:00:00"
  ];

  vendorSha256 = "sha256-bpuEEoWobFPVsNZKKuOKTQGvV+/NAgaM4M63bv5y0Rk=";

  subPackages = [ "cmd/cli/kubectl-kyverno" ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    # we have no integration between krew and kubectl
    # so better rename binary to kyverno and use as a standalone
    mv $out/bin/kubectl-kyverno $out/bin/kyverno
    installShellCompletion --cmd kyverno \
      --bash <($out/bin/kyverno completion bash) \
      --zsh <($out/bin/kyverno completion zsh) \
      --fish <($out/bin/kyverno completion fish)
  '';

  passthru.tests.version = testers.testVersion {
    package = kyverno;
    command = "kyverno version";
    inherit version;
  };

  meta = with lib; {
    description = "Kubernetes Native Policy Management";
    homepage = "https://kyverno.io/";
    changelog = "https://github.com/kyverno/kyverno/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bryanasdev000 ];
  };
}
