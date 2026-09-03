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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "gcx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RbXa5ZCGOy9TQ/Cm/21JES4C0vl0owsFfLiMlEQ2MfQ=";
  };

  vendorHash = "sha256-OvIK8sgWUo3t0+oure7+PpU7SFzbLyppyeaWQtKyZXg=";

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
