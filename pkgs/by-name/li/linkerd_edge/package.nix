{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "linkerd-edge";
  version = "25.7.4";
  vendorHash = "sha256-6cUWeJA0nxUMd+mrrHccPu9slebwZGUR0yGxev3k4ls=";

  src = fetchFromGitHub {
    owner = "linkerd";
    repo = "linkerd2";
    tag = "edge-${finalAttrs.version}";
    hash = "sha256-HRwxH3FexT0n/Z41Ixn95/ohIJ7Kxv0R2q5647ITQ6c=";
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

  passthru.updateScript = (./. + "/update-edge.sh");

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
