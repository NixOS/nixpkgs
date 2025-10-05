{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "havn";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "mrjackwills";
    repo = "havn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T4/mhHt5qe1b9/BzMbecMBjDWXpft5xfyjzST3OV/38=";
  };

  cargoHash = "sha256-YFgfTOBY1MsTvar0G2zdpDiTya8P++VlAP94hYKpBYc=";

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
