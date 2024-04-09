{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, rosa, nix-update-script }:

buildGoModule rec {
  pname = "rosa";
  version = "1.2.36";

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "rosa";
    rev = "v${version}";
    hash = "sha256-jdLMQLbk446QJ+8+HjTCTjtlCuLlZZsLUBInRg4UMH0=";
  };
  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd rosa \
      --bash <($out/bin/rosa completion bash) \
      --fish <($out/bin/rosa completion fish) \
      --zsh <($out/bin/rosa completion zsh)
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = rosa;
      command = "rosa version --client";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "CLI for the Red Hat OpenShift Service on AWS";
    license = licenses.asl20;
    homepage = "https://github.com/openshift/rosa";
    maintainers = with maintainers; [ jfchevrette ];
  };
}
