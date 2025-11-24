{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  kubedog,
}:

buildGoModule rec {
  pname = "kubedog";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "werf";
    repo = "kubedog";
    rev = "v${version}";
    hash = "sha256-xBTz1Ux2W0A0leOPNu0yONiz55LiYcYiviKEi8xsUTU=";
  };

  vendorHash = "sha256-kCS7nMFskBw6LTV5EgPSufxo78OyfW9Zdqe5rZytgKE=";

  subPackages = [ "cmd/kubedog" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/werf/kubedog.Version=${src.rev}"
  ];

  # There are no tests.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = kubedog;
    command = "kubedog version";
    version = src.rev;
  };

  meta = with lib; {
    description = ''
      A tool to watch and follow Kubernetes resources in CI/CD deployment
      pipelines
    '';
    mainProgram = "kubedog";
    homepage = "https://github.com/werf/kubedog";
    changelog = "https://github.com/werf/kubedog/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ azahi ];
  };
}
