{
  lib,
  runTest,
}:
let
  tests = {
    additionalFiles = ./additional-files.nix;
    bios = ./bios.nix;
    checksum = ./checksum.nix;
    secureBoot = ./secure-boot.nix;
    specialisations = ./specialisations.nix;
    stableEntry = ./stable-entry.nix;
    uefi = ./uefi.nix;
    distroName = ./distroName.nix;
  };
in
lib.mapAttrs (_: runTest) tests
// {
  # The same tests, installed with limine-install-ng.
  ng = lib.mapAttrs (
    name: test:
    runTest {
      imports = [ test ];
      name = lib.mkForce "${name}-ng";
      defaults.boot.loader.limine.enableNg = true;
    }
  ) tests;
}
