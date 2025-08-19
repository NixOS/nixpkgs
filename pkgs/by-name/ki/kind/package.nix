{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  nix-update-script,
  kind,
}:

buildGoModule rec {
  pname = "kind";
  version = "0.29.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "kubernetes-sigs";
    repo = "kind";
    hash = "sha256-Dv4I50LQcr8fOaCCdaKkz+pHIG05UBQAdDs7gGngm4Y=";
  };

  patches = [
    # fix kernel module path used by kind
    ./kernel-module-path.patch
  ];

  vendorHash = "sha256-QFDQkl1QuIc0fUK0raVxmPT7AF6fsKlQ4F0dzOM9fcw=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    installShellCompletion --cmd kind \
      --bash <($out/bin/kind completion bash) \
      --fish <($out/bin/kind completion fish) \
      --zsh <($out/bin/kind completion zsh)
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = kind;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Kubernetes IN Docker - local clusters for testing Kubernetes";
    homepage = "https://github.com/kubernetes-sigs/kind";
    maintainers = with maintainers; [
      offline
      rawkode
    ];
    license = licenses.asl20;
    mainProgram = "kind";
  };
}
