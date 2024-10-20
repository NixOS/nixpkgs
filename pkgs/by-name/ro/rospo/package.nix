{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "rospo";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "ferama";
    repo = "rospo";
    rev = "v${version}";
    hash = "sha256-+1xrke8dfMkuZZ/imY+1KkeJnZCDtKJpxwAg5ksErnM=";
  };

  vendorHash = "sha256-MTPFBrLFMQ2hEwtSDb7t3ls/Wagw7s9/w6bwWjZ62vE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ferama/rospo/cmd.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd rospo \
      --bash <($out/bin/rospo completion bash) \
      --fish <($out/bin/rospo completion fish) \
      --zsh <($out/bin/rospo completion zsh)
  '';

  meta = {
    description = "Simple, reliable, persistent ssh tunnels with embedded ssh server";
    homepage = "https://github.com/ferama/rospo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "rospo";
  };
}
