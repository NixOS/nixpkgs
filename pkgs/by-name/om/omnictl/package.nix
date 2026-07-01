{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "omnictl";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "omni";
    rev = "v${version}";
    hash = "sha256-xL1kZafjDQ9UkaBBs9n2u5t8jcL3CONv41hg3oA8x7s=";
  };

  vendorHash = "sha256-D88+xYpZgawfMLa7qJOL+5MAtSswat4ITY7sjCrJMVg=";

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
