{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "helm";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "0gx5gmj1470q3gj8v043dmm31skf83p1ckzdcfzx8wdjlglsljrj";
  };
  modSha256 = "0xjzzwmq3i77anb7w2qfnz7vc0gxq02lylj0xs6dzwl543winshm";

  goPackagePath = "k8s.io/helm";
  subPackages = [ "cmd/helm" ];
  buildFlagsArray = [ "-ldflags=-w -s -X helm.sh/helm/v3/internal/version.gitCommit=v${version}" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/kubernetes/helm;
    description = "A package manager for kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ rlupton20 edude03 saschagrunert ];
  };
}
