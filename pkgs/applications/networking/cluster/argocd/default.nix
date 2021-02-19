{ lib, buildGoModule, fetchFromGitHub, packr }:

buildGoModule rec {
  pname = "argocd";
  version = "1.8.4";
  commit = "28aea3dfdede00443b52cc584814d80e8f896200";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-cd";
    rev = "v${version}";
    sha256 = "sha256:155396rnihha31jxy0zk1jykiirpv4dhc69w45y6nx3nx4k0gwhk";
  };

  vendorSha256 = "sha256-6DOay+aeXz7EQKe5SzQSmg/5KyUI0g6wzPgx/+F2RW4=";

  doCheck = false;

  nativeBuildInputs = [ packr ];

  buildFlagsArray = ''
     -ldflags=
      -X github.com/argoproj/argo-cd/common.version=${version}
      -X github.com/argoproj/argo-cd/common.buildDate=unknown
      -X github.com/argoproj/argo-cd/common.gitCommit=${commit}
      -X github.com/argoproj/argo-cd/common.gitTreeState=clean
  '';

  # run packr to embed assets
  preBuild = ''
    packr
  '';

  meta = with lib; {
    description = "Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes";
    homepage = "https://github.com/argoproj/argo";
    license = licenses.asl20;
    maintainers = with maintainers; [ shahrukh330 ];
  };
}
