{
  lib,
  rustPlatform,
  pkg-config,
  openssl,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "commit-lsp";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "texel-sensei";
    repo = "commit-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N+KKIGvza5pTaUkn2zYHSB7pvzhkXricwvG/8jZ/TGE=";
  };

  cargoHash = "sha256-u2Ts1az7+31jv8jKsSKmhxyhu5adLIe3WUjTzgZTMh0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "LSP Server for providing linting and autocompletion inside of git commit messages";
    homepage = "https://github.com/texel-sensei/commit-lsp";
    changelog = "https://github.com/texel-sensei/commit-lsp/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "commit-lsp";
    platforms = lib.platforms.unix;
  };
})
