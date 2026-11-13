{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "az-pim-cli";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "netr0m";
    repo = "az-pim-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-skFmB2ms0sruEiQ9bTXvOqNrFQgWoc0ZbbF+Zsdbhg0=";
  };

  patches = [
    # removes info we don't have from version command
    ./version-build-info.patch
  ];

  vendorHash = "sha256-Hauq5AGWpKRtuHspyzfl7Gz5GUJmBRZ/ndH4dIWSOM8=";

  nativeBuildInputs = [
    installShellFiles
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-X github.com/netr0m/az-pim-cli/cmd.version=v${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd az-pim-cli \
      --bash <($out/bin/az-pim-cli completion bash) \
      --fish <($out/bin/az-pim-cli completion fish) \
      --zsh <($out/bin/az-pim-cli completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "List and activate Azure Entra ID Privileged Identity Management roles from the CLI";
    homepage = "https://github.com/netr0m/az-pim-cli";
    changelog = "https://github.com/netr0m/az-pim-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.da157 ];
    mainProgram = "az-pim-cli";
  };
})
