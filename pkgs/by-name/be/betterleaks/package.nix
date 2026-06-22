{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "betterleaks";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "betterleaks";
    repo = "betterleaks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7Oa6mtFhkHqgd4/FH85W7Bc/KSMwPCeHRhIFk2KVkik=";
  };

  vendorHash = "sha256-KAZfl2t8LUsgQBKsrgXsh/1ziX0FZvDhnSUAv7D/hSA=";

  ldflags = [
    "-s"
    "-X=github.com/betterleaks/betterleaks/version.Version=${finalAttrs.version}"
  ];

  subPackages = [
    "."
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  env.CGO_ENABLED = 0;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd betterleaks \
      --bash <($out/bin/betterleaks completion bash) \
      --fish <($out/bin/betterleaks completion fish) \
      --zsh <($out/bin/betterleaks completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/betterleaks";
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scan code for secrets";
    homepage = "https://github.com/betterleaks/betterleaks";
    changelog = "https://github.com/betterleaks/betterleaks/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "betterleaks";
  };
})
