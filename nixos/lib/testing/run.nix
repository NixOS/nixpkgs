{ config, hostPkgs, lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options = {
    passthru = mkOption {
      type = types.lazyAttrsOf types.raw;
      description = ''
        Attributes to add to the returned derivations,
        which are not necessarily part of the build.

        This is a bit like doing `drv // { myAttr = true; }` (which would be lost by `overrideAttrs`).
        It does not change the actual derivation, but adds the attribute nonetheless, so that
        consumers of what would be `drv` have more information.
      '';
    };

    run = mkOption {
      type = types.package;
      description = ''
        Derivation that runs the test.
      '';
    };
  };

  config = {
    run = hostPkgs.stdenv.mkDerivation {
      name = "vm-test-run-${config.name}";

      requiredSystemFeatures = [ "kvm" "nixos-test" ];

      buildCommand =
        ''
          mkdir -p $out

          # effectively mute the XMLLogger
          export LOGFILE=/dev/null

          ${config.driver}/bin/nixos-test-driver -o $out
        '';

      passthru = config.passthru;

      meta = config.meta;
    };

    # useful for inspection (debugging / exploration)
    passthru.config = config;
  };
}
