{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "macchina";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "Macchina-CLI";
    repo = "macchina";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GZO9xGc3KGdq2WdA10m/XV8cNAlQjUZFUVu1CzidJ5c=";
  };

  cargoHash = "sha256-B3dylFOMQ1a1DfemfQFFlLVKCmB+ipUMV45iDh8fSqY=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage doc/macchina.{1,7}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, minimal and customizable system information fetcher";
    homepage = "https://github.com/Macchina-CLI/macchina";
    changelog = "https://github.com/Macchina-CLI/macchina/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      _414owen
      progrm_jarvis
    ];
    mainProgram = "macchina";
  };
})
