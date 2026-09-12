{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdsf";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "hougesen";
    repo = "mdsf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f1hNGTAQoriCWL5g6b5MXej2Qc4pVAEf3k/J9eyHjVQ=";
  };

  cargoHash = "sha256-VjiJn9kvl+WtWKx7nvmw2ukAiEsO3hVCRSoR2XqjIO4=";

  # many tests fail for various reasons of which most depend on the build sandbox
  doCheck = false;

  nativeBuildInputs = [
    installShellFiles
  ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mdsf \
      --bash <($out/bin/mdsf completions bash) \
      --zsh <($out/bin/mdsf completions zsh) \
      --fish <($out/bin/mdsf completions fish) \
      --nushell <($out/bin/mdsf completions nushell)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Format markdown code blocks using your favorite tools";
    homepage = "https://github.com/hougesen/mdsf";
    changelog = "https://github.com/hougesen/mdsf/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "mdsf";
  };
})
