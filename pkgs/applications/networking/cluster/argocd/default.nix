{ lib, buildGoModule, fetchFromGitHub, packr }:

buildGoModule rec {
  pname = "argocd";
  version = "1.7.8";
  commit = "ef5010c3a0b5e027fd642732d03c5b0391b1e574";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-cd";
    rev = "v${version}";
    sha256 = "1pwk6mzmlsx43c75wl5lglpxgc2jkgzra4443hwp6n0wfgzajfp4";
  };

  vendorSha256 = "0c5gykijwjrq3cx9qg9hm5j7axccngc1kp5qj3429a2ilw80l8pl";

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
