{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    lib.mkOption
    types
    ;
  cfg = config.services.neard;
  format = pkgs.formats.ini { };
  configFile = format.generate "neard.conf" cfg.settings;
in
{
  options.services.neard = {
    enable = lib.mkEnableOption "neard, an NFC daemon";

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          General = {
            ConstantPoll = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Enable constant polling. Constant polling will automatically trigger a new
                polling loop whenever a tag or a device is no longer in the RF field.
              '';
            };

            DefaultPowered = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Automatically turn an adapter on when being discovered.
              '';
            };

            ResetOnError = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Power cycle the adapter when getting a driver error from the kernel.
              '';
            };
          };
        };
      };
      default = { };
      description = ''
        Neard INI-style configuration file as a Nix attribute set.

        See the upstream [configuration file](https://github.com/linux-nfc/neard/blob/master/src/main.conf).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."neard/main.conf".source = configFile;

    environment.systemPackages = [ pkgs.neard ];

    services.dbus.packages = [ pkgs.neard ];

    systemd.packages = [ pkgs.neard ];
  };
}
