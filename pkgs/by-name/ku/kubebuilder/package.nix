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

buildGoModule (finalAttrs: {
  pname = "kubebuilder";
  version = "4.13.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kubebuilder";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8rdi9jP4kRJCNOSzjDqD3MOccOq5/TXz6xubzilISco=";
  };

  vendorHash = "sha256-RcEFvXJze3rkaBbPjwYaZiEDqS2Ox6gug7A2HyO3Y8g=";

  subPackages = [
    "internal/cmd"
    "."
  ];

  allowGoReference = true;

  postPatch = ''
    substituteInPlace internal/version/version.go \
      --replace-fail "return main.Version" 'return "v${finalAttrs.version}"'
  '';

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
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "SDK for building Kubernetes APIs using CRDs";
    mainProgram = "kubebuilder";
    homepage = "https://github.com/kubernetes-sigs/kubebuilder";
    changelog = "https://github.com/kubernetes-sigs/kubebuilder/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cmars ];
  };
})
