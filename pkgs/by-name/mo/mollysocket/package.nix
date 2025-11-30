{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "mollysocket";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "mollyim";
    repo = "mollysocket";
    tag = version;
    hash = "sha256-F80XRQn3h1Y6dE8PVLGMTY29yZomrwqFAsm7h8euHw8=";
  };

  cargoHash = "sha256-BgmgxNxyuEXKLO9yoymJ0PUfL6/YSegGk8OMPjup/zo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    sqlite
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
