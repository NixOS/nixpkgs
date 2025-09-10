{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  git,
  go,
  gnumake,
  installShellFiles,
  testers,
  kubebuilder,
}:

buildGoModule rec {
  pname = "kubebuilder";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kubebuilder";
    rev = "v${version}";
    hash = "sha256-HUJ/dgDVN2hgCkO/iw3CqEgl8P2TbWgQ/TNe8uO3Vvk=";
  };

  vendorHash = "sha256-9hGIZgUyxMyOoxMn+KeN0+vmET2ISZtlejiaI5qUe40=";

  subPackages = [
    "cmd"
    "."
  ];

  allowGoReference = true;

  ldflags = [
    "-X sigs.k8s.io/kubebuilder/v4/cmd.kubeBuilderVersion=v${version}"
    "-X sigs.k8s.io/kubebuilder/v4/cmd.goos=${go.GOOS}"
    "-X sigs.k8s.io/kubebuilder/v4/cmd.goarch=${go.GOARCH}"
    "-X sigs.k8s.io/kubebuilder/v4/cmd.gitCommit=unknown"
    "-X sigs.k8s.io/kubebuilder/v4/cmd.buildDate=unknown"
  ];

  nativeBuildInputs = [
    makeWrapper
    git
    installShellFiles
  ];

  postInstall = ''
    wrapProgram $out/bin/kubebuilder \
      --prefix PATH : ${
        lib.makeBinPath [
          go
          gnumake
          git
        ]
      }

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

  meta = {
    description = "SDK for building Kubernetes APIs using CRDs";
    mainProgram = "kubebuilder";
    homepage = "https://github.com/kubernetes-sigs/kubebuilder";
    changelog = "https://github.com/kubernetes-sigs/kubebuilder/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cmars ];
  };
}
