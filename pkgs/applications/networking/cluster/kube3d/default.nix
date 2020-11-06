{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kube3d";
  version = "3.1.5";
  k3sVersion = "1.18.9-k3s1";

  excludedPackages = ''tools'';

  src = fetchFromGitHub {
    owner  = "rancher";
    repo   = "k3d";
    rev    = "v${version}";
    sha256 = "0aspkar9im323d8117k48fvh1yylyspi2p2l2f5rdg1ilpa6hm53";
  };

  buildFlagsArray = ''
    -ldflags=
      -w -s
      -X github.com/rancher/k3d/v3/version.Version=v${version}
      -X github.com/rancher/k3d/v3/version.K3sVersion=v${k3sVersion}
  '';

  nativeBuildInputs = [ installShellFiles ];

  # TODO: Move to enhanced installShellCompletion when in master: PR #83630
  postInstall = ''
    $out/bin/k3d completion bash > k3d.bash
    $out/bin/k3d completion fish > k3d.fish
    $out/bin/k3d completion zsh  > _k3d
    installShellCompletion k3d.{bash,fish} --zsh _k3d
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
