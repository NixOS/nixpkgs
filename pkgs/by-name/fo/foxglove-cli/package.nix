{
  stdenv,
  lib,
  buildGoModule,
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "foxglove-cli";
  version = "1.0.24";

  src = fetchFromGitHub {
    owner = "foxglove";
    repo = "foxglove-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JYaBVXSKn4zgWHq+s/tMgHCpQ2z5ZYh/+e+ex4MaUmo=";
  };

  vendorHash = "sha256-fL/eOGx81pdIPWHt14cf4VoIqmfUmbkKa8/y0QQKYko=";

  env.CGO_ENABLED = 0;
  tags = [ "netgo" ];
  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  modRoot = "foxglove";

  checkFlags =
    let
      skippedTests = [
        "TestDoExport"
        "TestExport"
        "TestExportCommand"
        "TestImport"
        "TestImportCommand"
        "TestLogin"
        "TestLoginCommand"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd foxglove \
        --bash <(${emulator} $out/bin/foxglove completion bash) \
        --fish <(${emulator} $out/bin/foxglove completion fish) \
        --zsh <(${emulator} $out/bin/foxglove completion zsh)
    ''
  );

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    changelog = "https://github.com/foxglove/foxglove-cli/releases/tag/v${finalAttrs.version}";
    description = "Interact with the Foxglove platform";
    downloadPage = "https://github.com/foxglove/foxglove-cli";
    homepage = "https://docs.foxglove.dev/docs/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sascha8a ];
    mainProgram = "foxglove";
  };
})
