{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "regexplain";
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kapilpokhrel";
    repo = "regexplain";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UtwRDFUjpgxgY+geAX4xmTYGgH897tKqxkIShzQEhWA=";
  };
  cargoHash = "sha256-6kNiF1ZEl25UuGoTrIph0NhJg422OW/dKtgOSYV7zxo=";

  meta = {
    description = "A terminal UI for explaining and visualizing regular expressions, kindof like regex101.";
    homepage = "https://github.com/kapilpokhrel/regexplain";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sntx
    ];
    mainProgram = "regexplain";
  };
})
