{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "pv-migrate";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = "pv-migrate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-secoT/SyL9YX5jyCtXHg7UlGnOWiVhWrejHw1FluYbs=";
  };

  subPackages = [ "cmd/pv-migrate" ];

  vendorHash = "sha256-mEgcw9B/V3/4aXQvZhccTOdmv5vKLmO0TI0qgx6oMCQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.version}"
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
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ivankovnatsky
      qjoly
    ];
  };
})
