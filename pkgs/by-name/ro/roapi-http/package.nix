{
  cmake,
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "roapi-http";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "roapi";
    repo = "roapi";
    rev = "roapi-http-v${finalAttrs.version}";
    sha256 = "sha256-qHAO3h+TTCQQ7vdd4CoXVGfKZ1fIxTWKqbUNnRsJaok=";
  };

  cargoHash = "sha256-PlQq2zttiheQ0WFBLuH4dBSuExK+7hP22aLfmtNtLCk=";

  buildAndTestSubdir = "roapi-http";

  nativeBuildInputs = [ cmake ];

  # snmalloc fails to compile on Darwin, and upstream doesn't use it for Linux
  buildNoDefaultFeatures = true;
  buildFeatures = [ "rustls" ];

  # the crate uses `#![deny(warnings)]`, which breaks with lints added by
  # newer rustc releases than the code was written against
  env.RUSTFLAGS = "--cap-lints warn";

  checkFlags = [ "--skip=test_http2" ]; # this test tries `curl` and fails

  meta = {
    description = "Create full-fledged APIs for static datasets without writing a single line of code";
    homepage = "https://roapi.github.io/docs/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.unix;
    mainProgram = "roapi-http";
  };
})
