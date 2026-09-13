{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alphai-tui";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "makeev";
    repo = "alphai-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BNNdoqyxvwQweD40kyl1hRDXDmsOX/WSy7GQy7jlRH8=";
  };

  cargoHash = "sha256-8HVs9cCOCxolF91i4kK31EYJkMqQirxbqg8oblBcdT8=";

  __structuredAttrs = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bloomberg-style stock dashboard for the terminal with live quotes, candlestick charts, AI-scored news, SEC Form 4 insider filings and earnings reads";
    homepage = "https://github.com/makeev/alphai-tui";
    changelog = "https://github.com/makeev/alphai-tui/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makeev ];
    mainProgram = "alphai-tui";
  };
})
