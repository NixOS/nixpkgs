{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kyverno-chainsaw";
  version = "0.1.6";
  cli = "chainsaw";

  src = fetchFromGitHub {
    owner = "kyverno";
    repo = "chainsaw";
    rev = "v${version}";
    hash = "sha256-14swkcv70qn1ka0pb3za9a4r15shm1aw93by2k3b1kx3qdar1bcs";
  };

  vendorHash = "sha256-466ad9e33cfd22ba799db99b21ab23d4";

  ldflags = [
    "-s" "-w"
    "-X github.com/kyverno/chainsaw/pkg/version.BuildVersion=v${version}"
    "-X github.com/kyverno/chainsaw/pkg/version.BuildHash=${version}"
    "-X github.com/kyverno/chainsaw/pkg/version.BuildTime=1970-01-01_00:00:00"
  ];

  meta = with lib; {
    description = "Chainsaw is a tool developed to run end to end tests in Kubernetes clusters.";
    homepage = "https://github.com/kyverno/chainsaw";
    changelog = "https://github.com/kyverno/chainsaw/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "chainsaw";
    maintainers = with maintainers; [ Sanskarzz ];
  };
}
