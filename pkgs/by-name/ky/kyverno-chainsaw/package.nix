{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kyverno-chainsaw";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "kyverno";
    repo = "chainsaw";
    rev = "v${version}";
    hash = "sha256-qn5EjddLVRhN90SICa39A28giXQ24Ol1nfbxNH5TXhc=";
  };

  vendorHash = "sha256-R9qaG19Vp+1a7AL0q8Cl1jN89cbXzLwbnN163WMWAEw=";

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
