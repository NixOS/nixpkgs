{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

let
  k3sVersion = "1.19.4-k3s1";
in
buildGoModule rec {
  pname = "kube3d";
  version = "3.4.0";

  excludedPackages = "tools";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "k3d";
    rev = "v${version}";
    sha256 = "1fisbzv786n841pagy7zbanll7k1g5ib805j9azs2s30cfhvi08b";
  };

  vendorSha256 = null;

  nativeBuildInputs = [ installShellFiles ];

  buildFlagsArray = [
    "-ldflags="
    "-w"
    "-s"
    "-X github.com/rancher/k3d/v3/version.Version=v${version}"
    "-X github.com/rancher/k3d/v3/version.K3sVersion=v${k3sVersion}"
  ];

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd k3d \
      --bash <($out/bin/k3d completion bash) \
      --fish <($out/bin/k3d completion fish) \
      --zsh <($out/bin/k3d completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/rancher/k3d";
    description = "A helper to run k3s (Lightweight Kubernetes. 5 less than k8s) in a docker container - k3d";
    longDescription = ''
      k3s is the lightweight Kubernetes distribution by Rancher: rancher/k3s

      k3d creates containerized k3s clusters. This means, that you can spin up a
      multi-node k3s cluster on a single machine using docker.
    '';
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kuznero jlesquembre ngerstle jk ];
  };
}
