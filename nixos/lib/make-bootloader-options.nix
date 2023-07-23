{ lib }:
/* Build a bootloader set of options */
let
  inherit (lib) mkOption types mdDoc;

  commonOptions = {
      id = mkOption {
        type = types.str;
        description = mdDoc "Identifier of this external bootloader for metadata";
        internal = true;
      };

      supportsInitrdSecrets = mkOption {
        type = types.bool;
        default = false;
        internal = true;
        description = mdDoc ''
          When unsupported and initrd secrets are configured,
          the system build will error out accordingly.
        '';
      };

      installHook = mkOption {
        type = types.package;
        internal = true;
        description = mdDoc ''
          An final installation script to be executed at activation-time
          to install this bootloader.

          It will receive the top-level path as an argument.
        '';
      };
  };
in
  bootloaderOptions: bootloaderOptions // commonOptions
