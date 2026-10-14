{
  lib,
  rustPlatform,
  src,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cake-wallet-dnssec-proof";
  version = "0.1.0-unstable-2025-08-15";

  inherit src;

  sourceRoot = "${finalAttrs.src.name}/rust";

  cargoHash = "sha256-g8flJYt15Go9/4wfWNapwmYGw2PgaBnY4dtz0lxs6gE=";

  passthru.libraryPath = "lib/libdnssec_proof.so";

  meta.license =
    with lib.licenses;
    OR [
      asl20
      mit
    ];
})
