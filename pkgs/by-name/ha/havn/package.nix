{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "havn";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "mrjackwills";
    repo = "havn";
    rev = "refs/tags/v${version}";
    hash = "sha256-BCg572435CdQMOldm3Ao4D+sDxbXUlDxMWmxa+aqTY0=";
  };

  cargoHash = "sha256-JaAlWiaOUoXSV6O4wmU7zCR5h5olO2zkB5WEGk2/ZdE=";

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
