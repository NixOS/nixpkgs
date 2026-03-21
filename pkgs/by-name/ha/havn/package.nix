{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "havn";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "mrjackwills";
    repo = "havn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cYhhNhrMrPvqEIrb9Vznap8UW2ZNhGSzsAEmgtGfmy4=";
  };

  cargoHash = "sha256-wcAdRS/ACBbnwN+vKmBLOpxw4SbrfTYo+E32PX6btTs=";

  checkFlags = [
    # Skip tests that require network access
    "--skip=scanner::tests::test_scanner_1000_80_443"
    "--skip=scanner::tests::test_scanner_all_80"
    "--skip=scanner::tests::test_scanner_port_80"
    "--skip=terminal::print::tests::test_terminal_monochrome_false"
  ];

  meta = {
    homepage = "https://github.com/mrjackwills/havn";
    description = "Fast configurable port scanner with reasonable defaults";
    changelog = "https://github.com/mrjackwills/havn/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "havn";
    platforms = lib.platforms.linux;
  };
})
