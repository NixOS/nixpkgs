{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "kube3d";
  version = "1.1.0";

  goPackagePath = "github.com/rancher/k3d";

  src = fetchFromGitHub {
    owner  = "rancher";
    repo   = "k3d";
    rev    = "v${version}";
    sha256 = "180q7a95znpkhfqcaw3asqrq22r6ppw98qsggp2wfm746mllg5pc";
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
