{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "linkerd-stable";
  version = "2.14.9";
  vendorHash = "sha256-bGl8IZppwLDS6cRO4HmflwIOhH3rOhE/9slJATe+onI=";

  src = fetchFromGitHub {
    owner = "linkerd";
    repo = "linkerd2";
    tag = "stable-${finalAttrs.version}";
    hash = "sha256-R/sxsPV2RnCUplC4f0pMxH9zMsNdPDXlmsxOpAAuvYw=";
  };

  subPackages = [ "cli" ];

  preBuild = ''
    env GOFLAGS="" go generate ./pkg/charts/static
    env GOFLAGS="" go generate ./jaeger/static
    env GOFLAGS="" go generate ./multicluster/static
    env GOFLAGS="" go generate ./viz/static
  '';

  tags = [
    "prod"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/linkerd/linkerd2/pkg/version.Version=${finalAttrs.src.tag}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv $out/bin/cli $out/bin/linkerd
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd linkerd \
      --bash <($out/bin/linkerd completion bash) \
      --zsh <($out/bin/linkerd completion zsh) \
      --fish <($out/bin/linkerd completion fish)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/linkerd version --client | grep ${finalAttrs.src.tag} > /dev/null
  '';

  passthru.updateScript = (./. + "/update-stable.sh");

  meta = {
    description = "Simple Kubernetes service mesh that improves security, observability and reliability";
    mainProgram = "linkerd";
    downloadPage = "https://github.com/linkerd/linkerd2/";
    homepage = "https://linkerd.io/";
    license = lib.licenses.asl20;
    maintainers = [
    ];
  };
})
