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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "gcx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gf05N13ZJLjB55eCcIfXIoJn3CVAAR5mcFyEq8s+RxY=";
  };

  vendorHash = "sha256-JioNpEqGFxD6Gg84ZZ/9OrETxTGn2V+HMlGGiiZfeIo=";

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
