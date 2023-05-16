{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, kyverno }:

buildGoModule rec {
  pname = "kyverno";
<<<<<<< HEAD
  version = "1.10.3";
=======
  version = "1.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kyverno";
    repo = "kyverno";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-SRDabFN0ITXwHzvE5m3pIAk42kQa2yINpT64x+k3r3g=";
=======
    sha256 = "sha256-R+08s8oQ/ZbaDwyYBshtot+g9OM7XAM6wZPf287wngg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  ldflags = [
    "-s" "-w"
    "-X github.com/kyverno/kyverno/pkg/version.BuildVersion=v${version}"
    "-X github.com/kyverno/kyverno/pkg/version.BuildHash=${version}"
    "-X github.com/kyverno/kyverno/pkg/version.BuildTime=1970-01-01_00:00:00"
  ];

<<<<<<< HEAD
  vendorHash = "sha256-YFlf0lqG4vWn9d5RAvi12ti/wV+qvsHWn123hhfmxRU=";
=======
  vendorHash = "sha256-jE1v9Ec4lEVcx+YjVtcsuNPCqr3x1pt8BMmC+OTwlRM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
