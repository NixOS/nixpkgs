{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "clusterctl";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "cluster-api";
    rev = "v${version}";
    sha256 = "sha256-npVtNSb7vCQ3dh0qN0GwJOdBIBvWzmQaWO+zFOI1F7g=";
  };

  vendorSha256 = "sha256-VO1Z4NUWrd4JuFYFg0a01psqoIM8ps3vKd0djR5OELU=";

  subPackages = [ "cmd/clusterctl" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = let t = "sigs.k8s.io/cluster-api/version"; in [
    "-X ${t}.gitMajor=${lib.versions.major version}"
    "-X ${t}.gitMinor=${lib.versions.minor version}"
    "-X ${t}.gitVersion=v${version}"
  ];

  postInstall = ''
    # errors attempting to write config to read-only $HOME
    export HOME=$(mktemp -d)

    installShellCompletion --cmd clusterctl \
      --bash <($out/bin/clusterctl completion bash) \
      --zsh <($out/bin/clusterctl completion zsh)
  '';

  meta = with lib; {
    description = "Kubernetes cluster API tool";
    homepage = "https://cluster-api.sigs.k8s.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ zowoq ];
  };
}
