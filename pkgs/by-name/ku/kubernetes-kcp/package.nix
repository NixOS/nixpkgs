{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  kubernetes-kcp,
}:

buildGoModule rec {
  pname = "kubernetes-kcp";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "kcp-dev";
    repo = "kcp";
    tag = "v${version}";
    hash = "sha256-rZLav2JOKzG5vW/wyfk7EIkOawsYOmG32OHXxkyyb3Y=";
  };
  vendorHash = "sha256-IuQzGme+CZqqD1VMO+rumbbc+ziPQaVJCyJNhMdU3jE=";

  subPackages = [ "cmd/kcp" ];

  # TODO: The upstream has the additional version information pulled from go.mod
  # dependencies.
  ldflags = [
    "-X k8s.io/client-go/pkg/version.gitCommit=unknown"
    "-X k8s.io/client-go/pkg/version.gitTreeState=clean"
    "-X k8s.io/client-go/pkg/version.gitVersion=v${version}"
    # "-X k8s.io/client-go/pkg/version.gitMajor=${KUBE_MAJOR_VERSION}"
    # "-X k8s.io/client-go/pkg/version.gitMinor=${KUBE_MINOR_VERSION}"
    "-X k8s.io/client-go/pkg/version.buildDate=unknown"
    "-X k8s.io/component-base/version.gitCommit=unknown"
    "-X k8s.io/component-base/version.gitTreeState=clean"
    "-X k8s.io/component-base/version.gitVersion=v${version}"
    # "-X k8s.io/component-base/version.gitMajor=${KUBE_MAJOR_VERSION}"
    # "-X k8s.io/component-base/version.gitMinor=${KUBE_MINOR_VERSION}"
    "-X k8s.io/component-base/version.buildDate=unknown"
  ];

  # TODO: Check if this is necessary.
  # __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/kcp completion bash > kcp.bash
    $out/bin/kcp completion zsh > kcp.zsh
    $out/bin/kcp completion fish > kcp.fish
    installShellCompletion kcp.{bash,zsh,fish}
  '';

  passthru.tests.version = testers.testVersion {
    package = kubernetes-kcp;
    command = "kcp --version";
    # NOTE: Once the go.mod version is pulled in, the version info here needs
    # to be also updated.
    version = "v${version}";
  };

  meta = {
    homepage = "https://kcp.io";
    description = "Kubernetes-like control planes for form-factors and use-cases beyond Kubernetes and container workloads";
    mainProgram = "kcp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      rytswd
    ];
  };
}
