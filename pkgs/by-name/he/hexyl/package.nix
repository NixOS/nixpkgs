{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "hexyl";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "hexyl";
    tag = "v${version}";
    hash = "sha256-TmFvv+jzOSM8kKCxBbUoDsUjKRPTplhWheVfIjS5nsY=";
  };

  cargoHash = "sha256-QjQoGtLF5BAxWFiLZZYCpwrYCdiVfvG/lAukCNZGsec=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line hex viewer";
    longDescription = ''
      `hexyl` is a simple hex viewer for the terminal. It uses a colored
      output to distinguish different categories of bytes (NULL bytes,
      printable ASCII characters, ASCII whitespace characters, other ASCII
      characters and non-ASCII).
    '';
    homepage = "https://github.com/sharkdp/hexyl";
    changelog = "https://github.com/sharkdp/hexyl/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      dywedir
      SuperSandro2000
    ];
    mainProgram = "hexyl";
  };
}
