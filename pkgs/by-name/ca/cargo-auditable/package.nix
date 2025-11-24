{
  buildPackages,
  callPackage,
  makeRustPlatform,
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

  hash = "sha256-zjv2/qZM0vRyz45DeKRtPHaamv2iLtjpSedVTEXeDr8=";
  cargoHash = "sha256-oTPGmoGlNfPVZ6qha/oXyPJp94fT2cNlVggbIGHf2bc=";
  version = "0.6.5";

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
}
