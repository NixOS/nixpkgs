{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gcx";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "gcx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6ZKlNLtP3dwPAIXGnupIk0wuXs+qMy2d2OreKfKJlxM=";
  };

  vendorHash = "sha256-FzhQfooCApBsnNH/cZYFfy3m4cDSBVX9ueaWfhTgx1k=";

  subPackages = [ "cmd/gcx" ];

  ldflags = [
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  __structuredAttrs = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gcx \
      --bash <($out/bin/gcx completion bash) \
      --fish <($out/bin/gcx completion fish) \
      --zsh <($out/bin/gcx completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Grafana Cloud CLI";
    homepage = "https://github.com/grafana/gcx";
    changelog = "https://github.com/grafana/gcx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "gcx";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ asimpson ];
  };
})
