{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hexyl";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "hexyl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1FlFvVgv4SslHtwXvHIE5aUXlDsUK4YFBtIKgsv/eB0=";
  };

  cargoHash = "sha256-/+0oRyA9gfucfBTdkN9Q5eUZOWNDIAOj634yAc7Hzn0=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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
    changelog = "https://github.com/sharkdp/hexyl/blob/v${finalAttrs.version}/CHANGELOG.md";
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
})
