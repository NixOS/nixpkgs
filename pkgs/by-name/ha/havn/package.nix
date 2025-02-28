{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "havn";
  version = "0.1.18";

  src = fetchFromGitHub {
    owner = "mrjackwills";
    repo = "havn";
    tag = "v${version}";
    hash = "sha256-G6nhWcrnMYysIHSocIeQsBGG51D1ozZPF/LGsDNG/+k=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LQAE/fgq2ixSrveTAKyd5zh1bl6znLhij04DD5wOTqw=";

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
