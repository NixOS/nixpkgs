{
  buildPackages,
  callPackage,
  makeRustPlatform,
  nix-update-script,
}:
let
  # Need to use the build platform rustc and Cargo so that
  # we don't infrec
  rustPlatform = makeRustPlatform {
    inherit (buildPackages) rustc;
    cargo = buildPackages.cargo.override {
      auditable = false;
    };
  };

  auditableBuilder = callPackage ./builder.nix {
    inherit rustPlatform;
    auditable-bootstrap = bootstrap;
  };

  version = "0.7.7";
  hash = "sha256-N/adXtdMJWaKiV2kc36RgDMEJ5Kx8ly+S7GrGabqjMI=";
  cargoHash = "sha256-A2gKYWy2MA0kZSbhgunoEhjO4V15X+NORQdBAoB1SeQ=";

  # cargo-auditable cannot be built with cargo-auditable until cargo-auditable is built
  bootstrap = auditableBuilder {
    inherit version hash cargoHash;
    pname = "cargo-auditable-bootstrap";
    auditable = false;
  };
in
auditableBuilder {
  inherit version hash cargoHash;
  auditable = true;
  passthru.updateScript = nix-update-script { };
}
