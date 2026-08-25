{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "havn";
  version = "0.3.9";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mrjackwills";
    repo = "havn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G+aUTzlpUfVTkoftp1igCPeKaQpbS4CyydoitcLzxjk=";
  };

  cargoHash = "sha256-G4DNr69FKiLI3vrEX3AMPn3DdWzPbxA7t2vw3bJtW94=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  checkFlags = [
    # Skip tests that require network access
    "--skip=scanner::tests::test_scanner_1000_80_443"
    "--skip=scanner::tests::test_scanner_all_80"
    "--skip=scanner::tests::test_scanner_port_80"
    "--skip=terminal::print::tests::test_terminal_monochrome_false"
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/mrjackwills/havn";
    description = "Fast configurable port scanner with reasonable defaults";
    changelog = "https://github.com/mrjackwills/havn/blob/v${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "havn";
    platforms = lib.platforms.linux;
  };
})
