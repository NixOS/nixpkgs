{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, git
, go
, gnumake
}:

buildGoModule rec {
  pname = "kubebuilder";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kubebuilder";
    rev = "v${version}";
    sha256 = "sha256-nLjmz9OakBLTBWdYA6czgtJmCuP96abNwLcLZo+yZ48=";
  };
  vendorSha256 = "sha256-xljLDwubwr6rZ/ZpW9/WithClaMo88ivlBhWFb0iAvo=";

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
      --prefix PATH : ${lib.makeBinPath [ go gnumake ]}
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
