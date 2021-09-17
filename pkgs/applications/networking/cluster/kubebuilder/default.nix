{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, git
, go
}:

buildGoModule rec {
  pname = "kubebuilder";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kubebuilder";
    rev = "v${version}";
    sha256 = "0bl5ff2cplal6hg75800crhyviamk1ws85sq60h4zg21hzf21y68";
  };
  vendorSha256 = "0zxyd950ksjswja64rfri5v2yaalfg6qmq8215ildgrcavl9974n";

  subPackages = ["cmd"];

  ldflags = [
    "-X main.kubeBuilderVersion=v${version}"
    "-X main.goos=${go.GOOS}"
    "-X main.goarch=${go.GOARCH}"
    "-X main.gitCommit=v${version}"
    "-X main.buildDate=v${version}"
  ];

  doCheck = true;

  postInstall = ''
    mv $out/bin/cmd $out/bin/kubebuilder
    wrapProgram $out/bin/kubebuilder \
      --prefix PATH : ${lib.makeBinPath [ go ]}
  '';

  allowGoReference = true;
  nativeBuildInputs = [ makeWrapper git ];

  meta = with lib; {
    homepage = "https://github.com/kubernetes-sigs/kubebuilder";
    description = "SDK for building Kubernetes APIs using CRDs";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmars ];
  };
}
