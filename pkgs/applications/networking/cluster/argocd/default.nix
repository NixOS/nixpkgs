{ lib, buildGoModule, fetchFromGitHub, packr }:

buildGoModule rec {
  pname = "argocd";
  version = "1.4.2";
  commit = "48cced9d925b5bc94f6aa9fa4a8a19b2a59e128a";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-cd";
    rev = "v${version}";
    sha256 = "01vsyrks1k5yfvrarv8ia0isr7snilr21b7lfiy860si82r2r8hj";
  };

  modSha256 = "1qivg7yy7ymmgkrvl365x29d8jnsphbz18j1ykgwwysyw3n4jkdg";

  nativeBuildInputs = [ packr ];

  patches = [ ./use-go-module.patch ];

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
