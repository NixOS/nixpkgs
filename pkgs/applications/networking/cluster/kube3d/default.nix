{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kube3d";
  version = "3.0.0";
  k3sVersion = "1.18.6-k3s1";

  goPackagePath = "github.com/rancher/k3d";
  excludedPackages = ''tools'';

  src = fetchFromGitHub {
    owner  = "rancher";
    repo   = "k3d";
    rev    = "v${version}";
    sha256 = "1p4rqzi67cr8vf1ih7zqxkpssqq0vy4pb5crvkxbbf5ad5mwrjri";
  };

  buildFlagsArray = ''
    -ldflags=
      -w -s
      -X github.com/rancher/k3d/v3/version.Version=v${version}
      -X github.com/rancher/k3d/v3/version.K3sVersion=v${k3sVersion}
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
   for shell in bash zsh; do
     $out/bin/k3d completion $shell > k3d.$shell
     installShellCompletion k3d.$shell
   done
  '';

  vendorSha256 = null;

  meta = with stdenv.lib; {
    homepage = "https://github.com/rancher/k3d";
    description = "A helper to run k3s (Lightweight Kubernetes. 5 less than k8s) in a docker container";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kuznero jlesquembre ngerstle ];
  };
}
