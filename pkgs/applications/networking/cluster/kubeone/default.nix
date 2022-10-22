{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, kubeone
, testers
}:

buildGoModule rec {
  pname = "kubeone";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "kubermatic";
    repo = "kubeone";
    rev = "v${version}";
    sha256 = "sha256-8wYrDGykob1YLvtscQdL867vuRv8J83DC7AzvQVXVr8=";
  };

  vendorSha256 = "sha256-Y4eivDchnN2rtQWjFY3cFiJXRfj48UfVUKM/OLuWXGA=";

  ldflags = [
    "-s -w"
    "-X k8c.io/kubeone/pkg/cmd.version=${version}"
    "-X k8c.io/kubeone/pkg/cmd.date=unknown"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd kubeone \
      --bash <($out/bin/kubeone completion bash) \
      --zsh <($out/bin/kubeone completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = kubeone;
    command = "kubeone version";
  };

  meta = {
    description = "Automate cluster operations on all your cloud, on-prem, edge, and IoT environments.";
    homepage = "https://kubeone.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lblasc ];
  };
}
