{
  extendModules,
  hostPkgs,
  lib,
  ...
}:
let
  # `meta.platforms` is not dependent on Nixpkgs configuration, so this should
  # be constant (which is a stronger guarantee than we even need fwiw)
  qemuPlatforms = hostPkgs.qemu.meta.platforms;

  systemToPkgs =
    system:
    # This should instead be taken from a place where it's memoized,
    # e.g. the flake (if this is consumed via the flake), or a file that
    # contains something like `legacyPackages` as its only contents.
    # That way we don't evaluate a new Nixpkgs for every test, when multiple
    # tests are requested in the same Nix evaluation process.
    import ../../../pkgs/top-level/default.nix {
      localSystem = system;
    };

  useVMPlatform =
    system:
    let
      hostPkgs = systemToPkgs system;
      configuration = extendModules {
        specialArgs = { inherit hostPkgs; };
      };
    in
    configuration.config.test;

in
{
  config.passthru.onVMHost =
    lib.genAttrs qemuPlatforms useVMPlatform
    // lib.optionalAttrs (builtins ? currentSystem) {
      currentSystem = useVMPlatform builtins.currentSystem;
    };
}
