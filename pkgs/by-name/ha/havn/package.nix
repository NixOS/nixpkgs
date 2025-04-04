{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "havn";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mrjackwills";
    repo = "havn";
    tag = "v${version}";
    hash = "sha256-zZiBVuA6rjsCfn0Ih3Sum0VsmtyXbfPG9fwK2zkwJaA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-j84DF6LJ9q56u4QgMFk9c6089Ghk5K0EatvonGjImjU=";

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
