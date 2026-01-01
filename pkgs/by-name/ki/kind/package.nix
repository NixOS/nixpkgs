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
<<<<<<< HEAD
  version = "0.31.0";
=======
  version = "0.30.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "kubernetes-sigs";
    repo = "kind";
<<<<<<< HEAD
    hash = "sha256-3icwtfwlSkYOEw9bzEhKJC7OtE1lnBjZSYp+cC/2XNc=";
=======
    hash = "sha256-TssyKO5v3xqSDjS3DYIlO7iOx/zzS3E9O88V9R7S5Ac=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Kubernetes IN Docker - local clusters for testing Kubernetes";
    homepage = "https://github.com/kubernetes-sigs/kind";
    maintainers = with lib.maintainers; [
      offline
      rawkode
    ];
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Kubernetes IN Docker - local clusters for testing Kubernetes";
    homepage = "https://github.com/kubernetes-sigs/kind";
    maintainers = with maintainers; [
      offline
      rawkode
    ];
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "kind";
  };
}
