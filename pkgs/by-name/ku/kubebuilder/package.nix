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
}:

buildGoModule (finalAttrs: {
  pname = "kubebuilder";
  version = "4.14.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kubebuilder";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ww8pHmbOdxK7ky2rWrPgGrdTUDCub7pxveNe1P3g850=";
  };

  vendorHash = "sha256-nzh/MvkSnyXoSawmaECkwz87qBTluS4FFHEGTrlsOeQ=";

  subPackages = [
    "internal/cli/cmd"
    "."
  ];

  allowGoReference = true;

  postPatch = ''
    substituteInPlace internal/cli/version/version.go \
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
    command = "${finalAttrs.finalPackage}/bin/kubebuilder version";
    package = finalAttrs.finalPackage;
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
