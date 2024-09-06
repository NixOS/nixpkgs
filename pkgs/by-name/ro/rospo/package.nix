{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "rospo";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "ferama";
    repo = "rospo";
    rev = "v${version}";
    hash = "sha256-cUah73wr0fKK9Lw3228r5SITDn5rNlpgQW5rHtbo6jU=";
  };

  vendorHash = "sha256-KbR8T7KwueQ9fc4AOX26GOTQFXuV9LgfSxgwCzQt4eE=";

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
