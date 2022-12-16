{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, clusterctl }:

buildGoModule rec {
  pname = "clusterctl";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "cluster-api";
    rev = "v${version}";
    sha256 = "sha256-Qaq0I7ZCXRXIWtUN3fcpoN4SURq/OfH+u73nyWYmJOY=";
  };

  vendorSha256 = "sha256-VDSMXE+Vlgmo7T1b+A7uW9BqSDBDyhrneJX1yH+XfDc=";

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
    description = "Kubernetes cluster API tool";
    homepage = "https://cluster-api.sigs.k8s.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ zowoq ];
  };
}
