{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  nix-update-script,
  kind,
}:

buildGoModule rec {
  pname = "kind";
  version = "0.30.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "kubernetes-sigs";
    repo = "kind";
    hash = "sha256-TssyKO5v3xqSDjS3DYIlO7iOx/zzS3E9O88V9R7S5Ac=";
  };

  patches = [
    # fix kernel module path used by kind
    ./kernel-module-path.patch
  ];

  vendorHash = "sha256-tRpylYpEGF6XqtBl7ESYlXKEEAt+Jws4x4VlUVW8SNI=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
