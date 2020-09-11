{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kube3d";
  version = "3.0.1";
  k3sVersion = "1.18.6-k3s1";

  excludedPackages = ''tools'';

  src = fetchFromGitHub {
    owner  = "rancher";
    repo   = "k3d";
    rev    = "v${version}";
    sha256 = "1l6mh0dpf2bw9sxpn14iivv3pr8mj4favzx2hhn8k1j71cm1w4rj";
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

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/rancher/k3d";
    description = "A helper to run k3s (Lightweight Kubernetes. 5 less than k8s) in a docker container";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kuznero jlesquembre ngerstle ];
  };
}
