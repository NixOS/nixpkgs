{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "oras";
  version = "1.3.6";

  # required for tests
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "oras-project";
    repo = "oras";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N5wBhjyVsd4cM6gaQ5QUueviSp9UC318gShRpDY1qwo=";
  };

  vendorHash = "sha256-YAogNAoO37cCBLNO9j391mpcoIv1msNjnz+hYNOsvLo=";

  nativeBuildInputs = [ installShellFiles ];

  excludedPackages = [ "./test/e2e" ];

  ldflags = [
    "-s"
    "-w"
    "-X oras.land/oras/internal/version.Version=${finalAttrs.version}"
    "-X oras.land/oras/internal/version.BuildMetadata="
    "-X oras.land/oras/internal/version.GitTreeState=clean"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd oras \
      --bash <($out/bin/oras completion bash) \
      --fish <($out/bin/oras completion fish) \
      --zsh <($out/bin/oras completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    homepage = "https://oras.land/";
    changelog = "https://github.com/oras-project/oras/releases/tag/v${finalAttrs.version}";
    description = "Distribute artifacts across OCI registries with ease";
    mainProgram = "oras";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
      developer-guy
    ];
  };
})
