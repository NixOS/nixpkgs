{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, git
, go
, gnumake
, installShellFiles
, testers
, kubebuilder
}:

buildGoModule rec {
  pname = "kubebuilder";
  version = "3.14.1";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kubebuilder";
    rev = "v${version}";
    hash = "sha256-TMKixwZonYGPXIqOtgnuilbH7BaIRyqJU6uKtp9ANKM=";
  };

  vendorHash = "sha256-Hl01dFSffYv59zensKTjXWLXxwfkQYAO5xadlc5iBJY=";

  subPackages = ["cmd"];

  allowGoReference = true;

  ldflags = [
    "-X main.kubeBuilderVersion=v${version}"
    "-X main.goos=${go.GOOS}"
    "-X main.goarch=${go.GOARCH}"
    "-X main.gitCommit=unknown"
    "-X main.buildDate=unknown"
  ];

  nativeBuildInputs = [
    makeWrapper
    git
    installShellFiles
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/kubebuilder
    wrapProgram $out/bin/kubebuilder \
      --prefix PATH : ${lib.makeBinPath [ go gnumake ]}

    installShellCompletion --cmd kubebuilder \
      --bash <($out/bin/kubebuilder completion bash) \
      --fish <($out/bin/kubebuilder completion fish) \
      --zsh <($out/bin/kubebuilder completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    command = "${kubebuilder}/bin/kubebuilder version";
    package = kubebuilder;
    version = "v${version}";
  };

  meta = with lib; {
    description = "SDK for building Kubernetes APIs using CRDs";
    mainProgram = "kubebuilder";
    homepage = "https://github.com/kubernetes-sigs/kubebuilder";
    changelog = "https://github.com/kubernetes-sigs/kubebuilder/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmars ];
  };
}
