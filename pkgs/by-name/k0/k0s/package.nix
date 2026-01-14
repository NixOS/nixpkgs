{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
let
  version = "1.34.3+k0s.0";
  tag = "v${version}";
in
buildGoModule {
  pname = "k0s";
  inherit version;

  src = fetchFromGitHub {
    owner = "k0sproject";
    repo = "k0s";
    inherit tag;
    hash = "sha256-kHtdUdtP5lppFC3GBvPMmeCR3Rf/qvJf832CC8Axv/w=";
  };

  vendorHash = "sha256-Ldvd+Y3qPKI2VcYw903UluovhtsjJfeHTdwXZ7zm4TQ=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd k0s \
      --bash <($out/bin/k0s completion bash) \
      --zsh <($out/bin/k0s completion zsh) \
      --fish <($out/bin/k0s completion fish)
  '';

  tags = [ "noembedbins" ];

  # Some tests failed with: failed to locate k0s executable: K0S_PATH environment variable not set: stat /build/source/k0s: no such file or directory
  doCheck = false;

  meta = {
    description = "k0s - The Zero Friction Kubernetes";
    homepage = "https://github.com/k0sproject/k0s";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mrdev023
      twz123
    ];
    mainProgram = "k0s";
  };
}
