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

  version = "0.7.5";
  hash = "sha256-0VONJCv/msLcGenItWMLJ7DH79RTD6vsU9gX/nphh1g=";
  cargoHash = "sha256-/iAYib+xDQSJ8B559/V7b994ErSUGsPSDx64jFF5B6I=";

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
