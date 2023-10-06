{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, clusterctl }:

buildGoModule rec {
  pname = "clusterctl";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "cluster-api";
    rev = "v${version}";
    hash = "sha256-yzk2zIk3igi7xlOi8RlGsthxy/M051SsiLi2v0gMWYk=";
  };

  vendorHash = "sha256-FUimSBMZI4BDtNKnlzmxe2HiL7MGIUh7SFC2dwWYT3I=";

  subPackages = [ "cmd/clusterctl" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = let t = "sigs.k8s.io/cluster-api/version"; in [
    "-X ${t}.gitMajor=${lib.versions.major version}"
    "-X ${t}.gitMinor=${lib.versions.minor version}"
    "-X ${t}.gitVersion=v${version}"
  ];

  postInstall = ''
    # errors attempting to write config to read-only $HOME
    export HOME=$TMPDIR

    installShellCompletion --cmd clusterctl \
      --bash <($out/bin/clusterctl completion bash) \
      --zsh <($out/bin/clusterctl completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = clusterctl;
    command = "HOME=$TMPDIR clusterctl version";
    version = "v${version}";
  };

  meta = with lib; {
    changelog = "https://github.com/kubernetes-sigs/cluster-api/releases/tag/${src.rev}";
    description = "Kubernetes cluster API tool";
    homepage = "https://cluster-api.sigs.k8s.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
