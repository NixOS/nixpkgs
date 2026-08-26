{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  libiconv,
  nix,
  testers,
  nixtract,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixtract";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "nixtract";
    rev = "v${finalAttrs.version}";
    hash = "sha256-g3+To12sWJnBd/XHzd5Hj4Bqpy8dxvpP6KUScD7xdc4=";
  };

  cargoHash = "sha256-u0T9L5F6LQUfqaH49YZwnpPCbsPbRewCjk/mQ17CLdM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
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
})
