{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "proton-cli";
  version = "5.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "roman-16";
    repo = "proton-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ibaGmpHbs13+eumBxRi9khIH6dHVgiF/1Qk0Z9Ydigs=";
  };

  vendorHash = "sha256-+LubOqMcqhdm4v2Ex43Y3ZD4hiImFI9ZH9MPJfAeenM=";

  subPackages = [ "cmd/proton" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/roman-16/proton-cli/internal/cli.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    ln -s proton $out/bin/proton-cli
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd proton \
      --bash <($out/bin/proton completion bash) \
      --fish <($out/bin/proton completion fish) \
      --zsh  <($out/bin/proton completion zsh)
    installShellCompletion --cmd proton-cli \
      --bash <($out/bin/proton completion bash) \
      --fish <(echo 'complete -c proton-cli -w proton')
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for Proton Mail, Drive, Calendar, Pass and Contacts, end-to-end encrypted";
    homepage = "https://proton-cli.lerchster.dev/";
    changelog = "https://github.com/roman-16/proton-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "proton";
    maintainers = with lib.maintainers; [ roman-16 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
