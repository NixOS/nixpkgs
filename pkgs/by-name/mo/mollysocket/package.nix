{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  stdenv,
  darwin,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "mollysocket";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "mollyim";
    repo = "mollysocket";
    rev = version;
    hash = "sha256-6SS1OyAkjL2K87wbUmDs+dDSLp3xL65CkM2AziuN0JQ=";
  };

  cargoHash = "sha256-gdHd10MfY7owKsLCsYCy4KIClnsgBzak6ZfghYuVDOc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  checkFlags = [
    # tests interact with Signal servers
    "--skip=config::tests::check_wildcard_endpoint"
    "--skip=utils::post_allowed::tests::test_allowed"
    "--skip=utils::post_allowed::tests::test_not_allowed"
    "--skip=utils::post_allowed::tests::test_post"
    "--skip=ws::tls::tests::connect_untrusted_server"
    "--skip=ws::tls::tests::connect_trusted_server"
  ];

  passthru.tests = {
    inherit (nixosTests) mollysocket;
  };

  meta = {
    changelog = "https://github.com/mollyim/mollysocket/releases/tag/${version}";
    description = "Get Signal notifications via UnifiedPush";
    homepage = "https://github.com/mollyim/mollysocket";
    license = lib.licenses.agpl3Plus;
    mainProgram = "mollysocket";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
