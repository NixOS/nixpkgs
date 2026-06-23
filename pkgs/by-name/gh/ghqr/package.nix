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
  pname = "ghqr";
  version = "0.4.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "ghqr";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-KKuxl8odNdMom8l524Mac+sM/5ZdtpakLqazZDQcXJs=";
  };

  vendorHash = "sha256-la/yXEZzAIt9l0q0P7+N8yCW0BQie9sLmAhLFK1qyGE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/microsoft/ghqr/cmd/ghqr/commands.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd 'ghqr' \
      --bash <("$out/bin/ghqr" completion bash) \
      --zsh <("$out/bin/ghqr" completion zsh) \
      --fish <("$out/bin/ghqr" completion fish)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Evaluate your enterprise and organizations with GitHub best practices";
    homepage = "https://github.com/microsoft/ghqr";
    changelog = "https://github.com/microsoft/ghqr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
    mainProgram = "ghqr";
  };
})
