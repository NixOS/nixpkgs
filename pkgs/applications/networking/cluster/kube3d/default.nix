{ lib, buildGoModule, fetchFromGitHub, installShellFiles, k3sVersion ? "1.20.6-k3s1" }:

buildGoModule rec {
  pname = "kube3d";
  version = "4.4.7";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "k3d";
    rev = "v${version}";
    sha256 = "sha256-S1vHmXUCP1ayPo3vvHAbNCqNm1ueJ0jE4NUBvg5P3MU=";
  };

  vendorSha256 = null;

  nativeBuildInputs = [ installShellFiles ];

  excludedPackages = "\\(tools\\|docgen\\)";

  ldflags = let t = "github.com/rancher/k3d/v4/version"; in
    [
      "-s" "-w" "-X ${t}.Version=v${version}" "-X ${t}.K3sVersion=v${k3sVersion}"
    ];

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd k3d \
      --bash <($out/bin/k3d completion bash) \
      --fish <($out/bin/k3d completion fish) \
      --zsh <($out/bin/k3d completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/k3d --help
    $out/bin/k3d version | grep "k3d version v${version}"
    runHook postInstallCheck
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
