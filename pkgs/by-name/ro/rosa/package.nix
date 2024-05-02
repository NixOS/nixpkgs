{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, rosa }:

buildGoModule rec {
  pname = "rosa";
  version = "1.2.38";

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "rosa";
    rev = "v${version}";
    hash = "sha256-eS9mK5iK/fXWMpgA/RF7wYybcJtPDW/pIWo9Iw0I+K8=";
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

  passthru.tests.version = testers.testVersion {
    package = rosa;
    command = "rosa version --client";
  };

  meta = with lib; {
    description = "CLI for the Red Hat OpenShift Service on AWS";
    license = licenses.asl20;
    homepage = "https://github.com/openshift/rosa";
    maintainers = with maintainers; [ jfchevrette ];
  };
}
