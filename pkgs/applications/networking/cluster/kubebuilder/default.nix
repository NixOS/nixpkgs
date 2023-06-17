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
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kubebuilder";
    rev = "v${version}";
    hash = "sha256-W1FjmhZWBt/ThkSHHGAR4p1Vxal4WOCutlsHIDZeRZM=";
  };

  vendorHash = "sha256-/Kvn3KwSB/mxgBKM+383QHCnVTOt06ZP3gt7FGqA5aM=";

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
    homepage = "https://github.com/kubernetes-sigs/kubebuilder";
    changelog = "https://github.com/kubernetes-sigs/kubebuilder/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmars ];
  };
}
