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
  pname = "splash-cli";
  version = "0.9.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "joshi4";
    repo = "splash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hjtKZRDn1gZhqi1f7xgvcv9BD75dZ0ir1yyMuN6CyB0=";
  };

  vendorHash = "sha256-hLtRNl8H0GXK7IxvyWpFxiqdG03CY4BGUHsl+r9Y6R0=";

  ldflags = [
    "-s"
    "-X=github.com/joshi4/splash/cmd.version=${finalAttrs.version}"
    # Disable the built-in self-updater and its on-exit GitHub check
    "-X=github.com/joshi4/splash/cmd.externalUpdate=nix"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd splash \
      --bash <($out/bin/splash completion bash) \
      --fish <($out/bin/splash completion fish) \
      --zsh <($out/bin/splash completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Add color to your logs";
    homepage = "https://github.com/joshi4/splash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "splash";
  };
})
