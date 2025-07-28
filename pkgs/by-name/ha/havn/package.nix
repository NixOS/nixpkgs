{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "havn";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "mrjackwills";
    repo = "havn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SXsCJzKfm77/IH3H7L5STylusmlN9DN4xd12Vt6L3TM=";
  };

  cargoHash = "sha256-SwqajiyYrN0VTGtQo9+Tux8sBvEmWzOQQknQ9zTQ0hY=";

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
