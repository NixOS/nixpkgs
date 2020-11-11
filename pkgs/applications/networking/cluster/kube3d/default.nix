{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kube3d";
  version = "3.2.0";
  k3sVersion = "1.18.9-k3s1";

  excludedPackages = ''tools'';

  src = fetchFromGitHub {
    owner  = "rancher";
    repo   = "k3d";
    rev    = "v${version}";
    sha256 = "0jy0l8rvmwi0qznnvv97v50lfkpc2bwjmbnq4pxnmf9ih970wjwh";
  };

  buildFlagsArray = ''
    -ldflags=
      -w -s
      -X github.com/rancher/k3d/v3/version.Version=v${version}
      -X github.com/rancher/k3d/v3/version.K3sVersion=v${k3sVersion}
  '';

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd k3d \
      --bash <($out/bin/k3d completion bash) \
      --fish <($out/bin/k3d completion fish) \
      --zsh <($out/bin/k3d completion zsh)
  '';

  vendorSha256 = null;

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/rancher/k3d";
    description = "A helper to run k3s (Lightweight Kubernetes. 5 less than k8s) in a docker container";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kuznero jlesquembre ngerstle jk ];
  };
}
