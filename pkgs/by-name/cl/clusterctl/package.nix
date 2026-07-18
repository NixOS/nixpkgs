{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  clusterctl,
}:

buildGoModule (finalAttrs: {
  pname = "clusterctl";
  version = "1.13.4";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "cluster-api";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x/u4lWacCz3GpUCyC8ty4nPPQblEs9G7vucqSJSupEQ=";
  };

  vendorHash = "sha256-73hCBGzE9LB59L+GurlZeTV6K/FLJgtjQc3ku4JR+iM=";

  subPackages = [ "cmd/clusterctl" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags =
    let
      t = "sigs.k8s.io/cluster-api/version";
    in
    [
      "-X ${t}.gitMajor=${lib.versions.major finalAttrs.version}"
      "-X ${t}.gitMinor=${lib.versions.minor finalAttrs.version}"
      "-X ${t}.gitVersion=v${finalAttrs.version}"
    ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # errors attempting to write config to read-only $HOME
    export HOME=$TMPDIR

    installShellCompletion --cmd clusterctl \
      --bash <($out/bin/clusterctl completion bash) \
      --fish <($out/bin/clusterctl completion fish) \
      --zsh <($out/bin/clusterctl completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = clusterctl;
    command = "HOME=$TMPDIR clusterctl version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    changelog = "https://github.com/kubernetes-sigs/cluster-api/releases/tag/${finalAttrs.src.rev}";
    description = "Kubernetes cluster API tool";
    mainProgram = "clusterctl";
    homepage = "https://cluster-api.sigs.k8s.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ qjoly ];
  };
})
