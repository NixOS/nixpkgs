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
  version = "0.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "ghqr";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-MpCOeKMqLyZd2N1XL7bUHuCM7AjLgsHzQ1plUKMWn50=";
  };

  vendorHash = "sha256-8lyQ1LDT1GAs+UDOpLxI/6BneU6Hqyt+PWsZIkq2rHY=";

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
