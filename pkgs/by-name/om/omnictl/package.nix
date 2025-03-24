{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "omnictl";
  version = "0.47.1";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "omni";
    rev = "v${version}";
    hash = "sha256-/hv6YNaBfECFlf1xJCiSeWg+/PqmIa+Rtip6kFuHPCM=";
  };

  vendorHash = "sha256-BQn+3TEaHnJrzDZt3j/sB9Gbh4mQXhqfX0ssu+G+mg0=";

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
