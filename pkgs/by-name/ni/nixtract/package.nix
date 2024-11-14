{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  libiconv,
  darwin,
  nix,
  testers,
  nixtract,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixtract";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "nixtract";
    rev = "v${version}";
    hash = "sha256-36ciPNSlB1LU+UXP8MLakrBRRqbyiVFN8Jp/JbCe1OY=";
  };

  cargoHash = "sha256-fawBRIVcOhtDxxRYCf+HWYadoSB/ENKguTbS0M4odVU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  nativeCheckInputs = [ nix ];

  checkFlags = [
    # Requiring network access
    "--skip=nix::narinfo::tests::test_fetch"
    "--skip=nix::substituters::tests::test_from_flake_ref"
    # Requiring write to `/nix/var`
    "--skip=nix::substituters::tests::test_get_substituters"
    "--skip=tests::test_main_fixtures"
  ];

  passthru.tests.version = testers.testVersion { package = nixtract; };

  meta = {
    description = "CLI tool to extract the graph of derivations from a Nix flake";
    homepage = "https://github.com/tweag/nixtract";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    mainProgram = "nixtract";
    maintainers = with lib.maintainers; [ aleksana ];
  };
}
