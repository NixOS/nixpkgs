{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "openleadr-rs";
  version = "v0.1.3";
  src = fetchFromGitHub {
    owner = "OpenLEADR";
    repo = "openleadr-rs";
    rev = version;
    hash = "sha256-GaP3D711xahPHTfmr6m0Gty0qB/ceyoCpc8w/fTIOVM=";
  };
  cargoHash = "sha256-x3nQfwkz0R5ILgyaECtKqBsxSXFoSEqRdbs4Zp7taFM=";
  # Disable sqlx crate's compile-time checks that require a live database.
  # See https://github.com/launchbadge/sqlx/blob/main/sqlx-cli/README.md#force-building-in-offline-mode
  # and https://docs.rs/sqlx/latest/sqlx/macro.query.html#offline-mode
  SQLX_OFFLINE = "true";
  # Disable tests. Several tests in the client require a live database
  # connection. We avoid this by disabling all tests. This is bad, and there
  # is an outstanding issue on the upstream project's board to avoid depending
  # on live database connections inside tests. Perhaps there's a good way to
  # spin up a database in the context of the nix build for testing, but I
  # don't know it.
  # See https://github.com/orgs/OpenLEADR/projects/1?pane=issue&itemId=83420564
  doCheck = false;
  meta = {
    description = "OpenADR 3.0 VTN and VEN implementation in Rust";
    longDescription = ''
      OpenADR is a protocol for automated demand-response in electricity
      grids, like dynamic pricing or load shedding. The OpenADR alliance is
      responsible for the standard, which can be downloaded free of charge.
      This is an OpenADR 3.0 client (VEN) library and a server (VTN)
      implementation, both written in Rust.
    '';
    homepage = "https://github.com/OpenLEADR/openleadr-rs";
    license = with lib.licenses; [ mit ]; # Also licensed under Apache 2.0.
    maintainers = with lib.maintainers; [ benjaminedwardwebb ];
    platforms = lib.platforms.linux;
  };
}
