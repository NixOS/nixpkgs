{
  lib,
  rustPlatform,
  clippy,
  limine,
  nixosTests,
}:

rustPlatform.buildRustPackage {
  pname = "limine-install";
  version = "0.1.0";

  __structuredAttrs = true;

  src = builtins.filterSource (name: _: !(lib.hasSuffix ".nix" name)) ./.;

  cargoLock.lockFile = ./Cargo.lock;

  nativeCheckInputs = [ clippy ];

  preCheck = ''
    cargo clippy --all-targets -- -Dwarnings
  '';

  passthru.tests = nixosTests.limine.ng;

  meta = {
    description = "NixOS bootloader installer for Limine";
    mainProgram = "limine-install";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    inherit (limine.meta) maintainers;
  };
}
