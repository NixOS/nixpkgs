{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "proxyt";
  version = "0.0.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jaxxstorm";
    repo = "proxyt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6+MgmhacH0oZY9ksZdBpv/tH4su8EBtHOiBIbR3ZXxo=";
  };

  vendorHash = "sha256-eAOU4DRnvfHdIc3cXMCAHbw7AZJWkEk/u3ae+K43CVc=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/jaxxstorm/proxyt/cmd.Version=${finalAttrs.version}"
  ];

  env = {
    CGO_ENABLED = "0";
  };

  nativeBuildInputs = [ installShellFiles ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd proxyt \
      --bash <($out/bin/proxyt completion bash) \
      --fish <($out/bin/proxyt completion fish) \
      --zsh <($out/bin/proxyt completion zsh)
  '';

  meta = {
    changelog = "https://github.com/jaxxstorm/proxyt/releases/${finalAttrs.version}";
    description = "Simple proxy for the Tailscale control plane";
    homepage = "https://github.com/jaxxstorm/proxyt";
    license = lib.licenses.mit;
    mainProgram = "proxyt";
    maintainers = with lib.maintainers; [ marie ];
  };
})
