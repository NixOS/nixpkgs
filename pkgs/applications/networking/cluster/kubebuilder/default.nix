{ lib
, buildGo117Module
, fetchFromGitHub
, makeWrapper
, git
, go_1_17
, gnumake
}:

buildGo117Module rec {
  pname = "kubebuilder";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kubebuilder";
    rev = "v${version}";
    sha256 = "sha256-xLeS0vfYuLEdzuou67ViduaBf62+Yqk+scaCCK+Xetk=";
  };
  vendorSha256 = "sha256-zE/y9FAoUZBmWiUMWbc66CwkK0h7SEXzfZY3KkjtQ0A=";

  subPackages = ["cmd"];

  ldflags = [
    "-X main.kubeBuilderVersion=v${version}"
    "-X main.goos=${go_1_17.GOOS}"
    "-X main.goarch=${go_1_17.GOARCH}"
    "-X main.gitCommit=v${version}"
    "-X main.buildDate=v${version}"
  ];

  doCheck = true;

  postInstall = ''
    mv $out/bin/cmd $out/bin/kubebuilder
    wrapProgram $out/bin/kubebuilder \
      --prefix PATH : ${lib.makeBinPath [ go_1_17 gnumake ]}
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
