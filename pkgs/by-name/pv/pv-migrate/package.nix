{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "pv-migrate";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = "pv-migrate";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-6y4PC9dFTy/Pz3hu19XH7e2aIWGlGseQVL0XKkCIoKQ=";
  };

  subPackages = [ "cmd/pv-migrate" ];

  vendorHash = "sha256-IT44RdqcXq4sJbQtIGUaQUcEzJBmqXMjC5UuFxUkuM4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
    "-X main.commit=v${finalAttrs.version}"
    "-X main.date=1970-01-01-00:00:01"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pv-migrate \
      --bash <($out/bin/pv-migrate completion bash) \
      --fish <($out/bin/pv-migrate completion fish) \
      --zsh <($out/bin/pv-migrate completion zsh)
  '';

  meta = {
    mainProgram = "pv-migrate";
    description = "CLI tool to easily migrate Kubernetes persistent volumes";
    homepage = "https://github.com/utkuozdemir/pv-migrate";
    changelog = "https://github.com/utkuozdemir/pv-migrate/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.afl20;
    maintainers = with lib.maintainers; [
      ivankovnatsky
      qjoly
    ];
  };
})
