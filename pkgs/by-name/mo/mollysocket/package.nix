{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mollysocket";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "mollyim";
    repo = "mollysocket";
    tag = finalAttrs.version;
    hash = "sha256-AmbhTjf1KhDc6Y0yrXKzL6gPMJ9Wx8e8HqdbBHr7/cY=";
  };

  cargoHash = "sha256-/WUcaGrIQvPXrcOvSpEGR6mCiey1ULWcLpXzcpvEh7E=";

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
    changelog = "https://github.com/mollyim/mollysocket/releases/tag/${finalAttrs.version}";
    description = "Get Signal notifications via UnifiedPush";
    homepage = "https://github.com/mollyim/mollysocket";
    license = lib.licenses.agpl3Plus;
    mainProgram = "mollysocket";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
