{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "omnictl";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "omni";
    rev = "v${version}";
    hash = "sha256-8oTLe4ZGXqL62h+AbjjKv/SmDd9cMvFO3k/0K3VdrNI=";
  };

  vendorHash = "sha256-yO9b26bXCg5pSXX65vQf/8YII/92sDjGJMK40zu/3s8=";

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
