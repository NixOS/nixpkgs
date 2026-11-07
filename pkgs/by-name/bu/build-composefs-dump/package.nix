{
  lib,
  rustPlatform,
  clippy,
  nixosTests,
}:

rustPlatform.buildRustPackage {
  pname = "build-composefs-dump";
  version = "0.1.0";
  cargoLock.lockFile = ./Cargo.lock;

  src = builtins.filterSource (name: _: !(lib.hasSuffix ".nix" name)) ./.;

  nativeCheckInputs = [
    clippy
  ];

  preCheck = ''
    cargo clippy -- -Dwarnings
  '';

  passthru.tests = {
    inherit (nixosTests) activation-etc-overlay-immutable activation-etc-overlay-mutable;
  };

  __structuredAttrs = true;

  meta = {
    description = "NixOS script to build a composefs dump for etc as overlayfs";
    mainProgram = "build-composefs-dump";
    maintainers = [ lib.maintainers.lubsch ];
    license = lib.licenses.mit;
  };
}
