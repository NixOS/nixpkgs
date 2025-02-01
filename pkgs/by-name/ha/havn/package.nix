{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "havn";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "mrjackwills";
    repo = "havn";
    rev = "refs/tags/v${version}";
    hash = "sha256-z6505lMqNQ0FpMMRJwpOFodELfDeoIjrjG58mrfSvTY=";
  };

  cargoHash = "sha256-RzfIu2apaFacSJz29UTaCKcC7Y81uxj1EerVyxZB50E=";

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
    changelog = "https://github.com/mrjackwills/havn/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "havn";
    platforms = lib.platforms.linux;
  };
}
