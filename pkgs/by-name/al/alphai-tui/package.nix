{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cacert,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alphai-tui";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "makeev";
    repo = "alphai-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KhafMLwmMfqdchLchb+JKHLE2hGrLhJzHpLq6ziG0Mc=";
  };

  cargoHash = "sha256-4I+U/uo2Mwyr7/02XwgtRn7C5UiJFbJxj75ewmhSrU4=";

  __structuredAttrs = true;

  # The tests build HTTP clients, which load the system CA certificates, and
  # bind mock servers on localhost.
  __darwinAllowLocalNetworking = true;

  preCheck = ''
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bloomberg-style stock dashboard for the terminal";
    longDescription = ''
      alphai-tui is a stock dashboard for the terminal built on ratatui. It
      shows live quotes and candlestick charts from Yahoo Finance (no API key
      needed), Finnhub, Alpaca or Tiingo next to AI-scored news, SEC Form 4
      insider filings and earnings reads from the AlphAI API.
    '';
    homepage = "https://github.com/makeev/alphai-tui";
    changelog = "https://github.com/makeev/alphai-tui/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makeev ];
    mainProgram = "alphai-tui";
  };
})
