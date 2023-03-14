{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, testers
, kubedog
}:

buildGoModule rec {
  pname = "kubedog";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "werf";
    repo = "kubedog";
    rev = "v${version}";
    hash = "sha256-j7LR6+c2ZZJCqmHihXodtiF5bJhNR8eizDEqwm9IUn0=";
  };

  vendorHash = "sha256-UPfB3nOzJpqh14xLKZP2mLfg7C55nQivrkmh3B7aKzo=";

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
    homepage = "https://github.com/werf/kubedog";
    changelog = "https://github.com/werf/kubedog/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ azahi ];
  };
}
