{
  lib,
  stdenv,
  buildGoModule,
  installShellFiles,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pop";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "pop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZGJkpa1EIw3tt1Ww2HFFoYsnnmnSAiv86XEB5TPf4/k=";
  };

  vendorHash = "sha256-8YcJXvR0cdL9PlP74Qh6uN2XZoN16sz/yeeZlBsk5N8=";

  env.GOWORK = "off";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/pop man > pop.1
    installManPage pop.1
    installShellCompletion --cmd pop \
      --bash <($out/bin/pop completion bash) \
      --fish <($out/bin/pop completion fish) \
      --zsh <($out/bin/pop completion zsh)
  '';

  meta = {
    description = "Send emails from your terminal";
    homepage = "https://github.com/charmbracelet/pop";
    changelog = "https://github.com/charmbracelet/pop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      caarlos0
    ];
    mainProgram = "pop";
  };
})
