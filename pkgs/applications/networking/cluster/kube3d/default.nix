{ lib, buildGoModule, fetchFromGitHub, installShellFiles, k3sVersion ? "1.20.4-k3s1" }:

buildGoModule rec {
  pname = "kube3d";
  version = "4.3.0";

  excludedPackages = "tools";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "k3d";
    rev = "v${version}";
    sha256 = "sha256-ybEYKr0rQY8Qg74V1mXqShq5Z2d/Adf0bSSbEMIyo3I=";
  };

  vendorSha256 = null;

  nativeBuildInputs = [ installShellFiles ];

  preBuild = let t = "github.com/rancher/k3d/v4/version"; in
    ''
      buildFlagsArray+=("-ldflags" "-s -w -X ${t}.Version=v${version} -X ${t}.K3sVersion=v${k3sVersion}")
    '';

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd k3d \
      --bash <($out/bin/k3d completion bash) \
      --fish <($out/bin/k3d completion fish) \
      --zsh <($out/bin/k3d completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/rancher/k3d";
    changelog = "https://github.com/rancher/k3d/blob/v${version}/CHANGELOG.md";
    description = "A helper to run k3s (Lightweight Kubernetes. 5 less than k8s) in a docker container - k3d";
    longDescription = ''
      k3s is the lightweight Kubernetes distribution by Rancher: rancher/k3s

      k3d creates containerized k3s clusters. This means, that you can spin up a
      multi-node k3s cluster on a single machine using docker.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ kuznero jlesquembre ngerstle jk ];
    platforms = platforms.linux;
  };
}
