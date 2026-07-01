{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "layerx";
  version = "1.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deveshctl";
    repo = "layerx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bkz0ETQEdy0GOlyGFmP8y80NdmNgRvLV0xRf/zd91ZY=";
  };

  vendorHash = "sha256-7wbyz6fKB3HMFhKJVIWrOIczLfqF4yInyszdh2Ky8WU=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion \
      --cmd layerx \
      --bash <($out/bin/layerx completion bash) \
      --fish <($out/bin/layerx completion fish) \
      --zsh <($out/bin/layerx completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = [ "version" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based Docker image layer inspector";
    homepage = "https://github.com/deveshctl/layerx";
    changelog = "https://github.com/deveshctl/layerx/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "layerx";
  };
})
