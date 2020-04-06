{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kube3d";
  version = "1.6.0";
  k3sVersion = "1.17.3-k3s1";

  goPackagePath = "github.com/rancher/k3d";

  src = fetchFromGitHub {
    owner  = "rancher";
    repo   = "k3d";
    rev    = "v${version}";
    sha256 = "0qjwqqynvgzainq66fpzczgynwk3hv7wzgfy5271fc6mj2k0zz5x";
  };

  buildFlagsArray = ''
    -ldflags=
      -w -s
      -X github.com/rancher/k3d/version.Version=${version}
      -X github.com/rancher/k3d/version.K3sVersion=v${k3sVersion}
  '';

  modSha256 = "0c8bfl0hz5cfhi6jzhhylz051jiix6s7s20fn23w7wri4xaqrjn8";

  meta = with stdenv.lib; {
    homepage = "https://github.com/rancher/k3d";
    description = "A helper to run k3s (Lightweight Kubernetes. 5 less than k8s) in a docker container";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kuznero jlesquembre ngerstle ];
  };
}
