{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "bootdev-cli";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "bootdotdev";
    repo = "bootdev";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/vVT2daJCxJDmJr9Xi27POCAKURCS171ORb7UJp/CqU=";
  };

  vendorHash = "sha256-ZDioEU5uPCkd+kC83cLlpgzyOsnpj2S7N+lQgsQb8uY=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bootdev \
      --bash <($out/bin/bootdev completion bash) \
      --zsh <($out/bin/bootdev completion zsh) \
      --fish <($out/bin/bootdev completion fish)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/bootdev";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI used to complete coding challenges and lessons on Boot.dev";
    homepage = "https://github.com/bootdotdev/bootdev";
    changelog = "https://github.com/bootdotdev/bootdev/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vinnymeller ];
    mainProgram = "bootdev";
  };
})
