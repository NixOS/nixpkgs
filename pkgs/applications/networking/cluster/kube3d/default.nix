{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "kube3d";
  version = "1.3.1";

  goPackagePath = "github.com/rancher/k3d";

  src = fetchFromGitHub {
    owner  = "rancher";
    repo   = "k3d";
    rev    = "v${version}";
    sha256 = "0bdpjnzyxd6mdc1qv0ml89qds6305kn3wmyci2kv6g2y7r7wxvm2";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = "https://github.com/rancher/k3d";
    description = "A helper to run k3s (Lightweight Kubernetes. 5 less than k8s) in a docker container";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kuznero ];
  };
}
