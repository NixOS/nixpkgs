{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "envq";
  version = "0.1.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "techouse";
    repo = "envq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yVzyzJDlrQ/X2vWrItYnJ+4s/oFpFPWdIDPG4JBdfD0=";
  };

  cargoHash = "sha256-6mwR05TKP7wVwHk8XULbcOSneUgE0lPrA6+xRR8tIaE=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd envq \
      --bash <($out/bin/envq completion bash) \
      --zsh <($out/bin/envq completion zsh) \
      --fish <($out/bin/envq completion fish)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Byte-preserving .env query and editing tool";
    homepage = "https://techouse.github.io/envq/";
    changelog = "https://github.com/techouse/envq/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ techouse ];
    mainProgram = "envq";
    platforms = lib.platforms.unix;
  };
})
