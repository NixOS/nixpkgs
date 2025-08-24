{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "omnictl";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "omni";
    rev = "v${version}";
    hash = "sha256-T7sX3mIZl361tyG0q/diMakRFAMi7wtiJLfv5VeVHSg=";
  };

  vendorHash = "sha256-MdWEMUAAUH4cEyKnANLax05h6ZuhBIXEvOnJ1qOxvWE=";

  ldflags = [
    "-s"
    "-w"
  ];

  env.GOWORK = "off";

  subPackages = [ "cmd/omnictl" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd omnictl \
      --bash <($out/bin/omnictl completion bash) \
      --fish <($out/bin/omnictl completion fish) \
      --zsh <($out/bin/omnictl completion zsh)
  '';

  doCheck = false; # no tests

  meta = with lib; {
    description = "CLI for the Sidero Omni Kubernetes management platform";
    mainProgram = "omnictl";
    homepage = "https://omni.siderolabs.com/";
    license = licenses.bsl11;
    maintainers = with maintainers; [ raylas ];
  };
}
