{ config, hostPkgs, lib, ... }:
let
  inherit (lib) types mkOption mdDoc;
in
{
  options = {
    passthru = mkOption {
      type = types.lazyAttrsOf types.raw;
      description = mdDoc ''
        Attributes to add to the returned derivations,
        which are not necessarily part of the build.

        This is a bit like doing `drv // { myAttr = true; }` (which would be lost by `overrideAttrs`).
        It does not change the actual derivation, but adds the attribute nonetheless, so that
        consumers of what would be `drv` have more information.
      '';
    };

    test = mkOption {
      type = types.package;
      # TODO: can the interactive driver be configured to access the network?
      description = mdDoc ''
        Derivation that runs the test as its "build" process.

        This implies that NixOS tests run isolated from the network, making them
        more dependable.
      '';
    };
  };

  config = {
    test = lib.lazyDerivation { # lazyDerivation improves performance when only passthru items and/or meta are used.
      derivation = hostPkgs.stdenv.mkDerivation {
        name = "vm-test-run-${config.name}";

        requiredSystemFeatures = [ "kvm" "nixos-test" ];

        buildCommand = ''
          mkdir -p $out

          # effectively mute the XMLLogger
          export LOGFILE=/dev/null

          ${config.driver}/bin/nixos-test-driver -o $out
        '';

        passthru = config.passthru;

        meta = config.meta;
      };
      inherit (config) passthru meta;
    };

    # useful for inspection (debugging / exploration)
    passthru.config = config;
  };
}
