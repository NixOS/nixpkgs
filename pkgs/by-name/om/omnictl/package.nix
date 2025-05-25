{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "omnictl";
  version = "0.49.1";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "omni";
    rev = "v${version}";
    hash = "sha256-0SLeR91KVwpAKLLVVZ3pEKI2Vy0QaysezX2M3X5aZdQ=";
  };

  vendorHash = "sha256-dT0sniTYli+zRYN/uLETS3SrM5cfDY5ZYYAthaiQ93U=";

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
