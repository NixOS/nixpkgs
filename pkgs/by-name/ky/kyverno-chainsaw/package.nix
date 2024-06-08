{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kyverno-chainsaw";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "kyverno";
    repo = "chainsaw";
    rev = "v${version}";
    hash = "sha256-YMUT1Wz/jDLH8eMYtfevdww/X+jdM9KqHjUCMSCRRXM=";
  };

  vendorHash = "sha256-R2+HjziP0KtExYQ3ZPGZKkqfKinK3BBnxJJh454ed2w=";

  ldflags = [
    "-s" "-w"
    "-X github.com/kyverno/chainsaw/pkg/version.BuildVersion=v${version}"
    "-X github.com/kyverno/chainsaw/pkg/version.BuildHash=${version}"
    "-X github.com/kyverno/chainsaw/pkg/version.BuildTime=1970-01-01_00:00:00"
  ];

  doCheck = false; # requires running kubernetes

  meta = {
    changelog = "https://github.com/kyverno/chainsaw/releases/tag/v${version}";
    description = "Declarative approach to test Kubernetes operators and controllers";
    homepage = "https://kyverno.github.io/chainsaw/";
    license = lib.licenses.asl20;
    longDescription = ''
      Chainsaw is meant to test Kubernetes operators work as expected by running a sequence of test steps for:
      * Creating resources
      * Asserting operators react (or not) the way they should
    '';
    mainProgram = "chainsaw";
    maintainers = with lib.maintainers; [ Sanskarzz ];
  };
}
