{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  buildGoModule,
}:

buildGoModule rec {
  pname = "autorestic";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "cupcakearmy";
    repo = "autorestic";
    rev = "v${version}";
    sha256 = "sha256-rladzcW6l5eR6ICj4kKd4e2R9vRIV/1enCzHLFdQDlk=";
  };

  vendorHash = "sha256-riAjjIrG00vJweaFHc3ArhaAQb08v6cYUJsNys4Hwio=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd autorestic \
         --bash <($out/bin/autorestic completion bash) \
         --fish <($out/bin/autorestic completion fish) \
         --zsh <($out/bin/autorestic completion zsh)
  '';

  meta = with lib; {
    description = "High level CLI utility for restic";
    homepage = "https://github.com/cupcakearmy/autorestic";
    license = licenses.asl20;
    maintainers = with maintainers; [ renesat ];
    mainProgram = "autorestic";
  };
}
