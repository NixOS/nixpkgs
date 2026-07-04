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

  version = "0.7.2";
  hash = "sha256-hR6PjTOps8JSM7UbfGlCoZmmwtWExVqYwh4lxDiFWdc=";
  cargoHash = "sha256-JEfnUJ9J6Xak3AOCwQCnu+v+3Wl3QbXX20qVFWB6040=";

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
