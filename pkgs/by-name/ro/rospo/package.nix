{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "rospo";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "ferama";
    repo = "rospo";
    rev = "v${version}";
    hash = "sha256-H6hZbOnX+1P1Ob5fCROQtV+64NiFD9mO3kiaQY63OBM=";
  };

  vendorHash = "sha256-KyTDyV27YQDqbEyKSYfbJuTKw2EsZAqWsHhmMncUHUs=";

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
