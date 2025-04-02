{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "openleadr-rs";
  version = "v0.0.4";
  src = fetchFromGitHub {
    owner = "OpenLEADR";
    repo = "openleadr-rs";
    rev = version;
    hash = "sha256-bc9ph0MonynqBPxECLI4drCV/X/zs82CAjAofo+Dk4Q=";
  };
  cargoHash = "sha256-zjVCGJOSDWrPnLLOcY2I48qN1gGarClmMVVdOqM9SXs=";
  # Disable compile-time checks of SQL queries against live database.
  #
  # The sqlx rust crate's query*! macros require a live database connection
  # during compilation (ugh!) in order to support compile-time checked queries
  # (yay!). We disable this feature for now within the nix build context. Not
  # doing so yields errors like
  #
  #   error: error communicating with database: Connection refused (os error 111)
  #
  # during compilation.
  #
  # See https://github.com/launchbadge/sqlx/blob/main/sqlx-cli/README.md#force-building-in-offline-mode
  # and https://docs.rs/sqlx/latest/sqlx/macro.query.html#offline-mode
  SQLX_OFFLINE = "true";
  # Disable tests.
  #
  # Several tests in the client require a live database connection. Testing
  # without a database yields errors like
  #
  #   failed to connect to setup test database: PoolTimedOut
  #
  # and
  #
  #   error: test failed, to rerun pass `-p openadr-client --test basic-read`
  #
  # We avoid this by disabling all tests. This is bad, and there is an
  # outstanding issue on the upstream project's board to avoid depending on
  # live database connections inside tests. We may also be able to find a way
  # to spin up a database in the context of the nix build for testing.
  #
  # See https://github.com/orgs/OpenLEADR/projects/1?pane=issue&itemId=83420564
  doCheck = false;
  meta = {
    description = "Work-in-progress implementation of the OpenADR 3.0 specification";
    longDescription = ''
      This is a work-in-progress implementation of the OpenADR 3.0
      specification. OpenADR is a protocol for automatic demand-response in
      electricity grids, like dynamic pricing or load shedding.
    '';
    homepage = "https://github.com/OpenLEADR/openleadr-rs";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ benjaminedwardwebb ];
    platforms = lib.platforms.linux;
  };
}
