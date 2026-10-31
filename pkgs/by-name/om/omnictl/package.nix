{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo127Module rec {
  pname = "omnictl";
  version = "1.12.4";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "omni";
    rev = "v${version}";
    hash = "sha256-SwjNnZx+RXRu3nwhg4Tv9yZwDnOrwc8c9bHSbgAGJgg=";
  };

  vendorHash = "sha256-ZbXYuniPvBFnOgPC9LF0/haNdmkSNIZY0L7CxMMXR2s=";

  ldflags = [
    "-s"
    "-w"
  ];

  env.GOWORK = "off";

  subPackages = [ "cmd/omnictl" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd omnictl \
      --bash <($out/bin/omnictl completion bash) \
      --fish <($out/bin/omnictl completion fish) \
      --zsh <($out/bin/omnictl completion zsh)
  '';

  doCheck = false; # no tests

  meta = {
    description = "CLI for the Sidero Omni Kubernetes management platform";
    mainProgram = "omnictl";
    homepage = "https://omni.siderolabs.com/";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [ raylas ];
  };
}
