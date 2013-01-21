{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.nix.gc;
in

{

  ###### interface

  options = {
    nix.gc = {

      automatic = mkOption {
        default = false;
        type = types.bool;
        description = "
          Automatically run the garbage collector at specified dates.
        ";
      };

      dates = mkOption {
        default = "15 03 * * *";
        type = types.string;
        description = "
          Run the garbage collector at specified dates to avoid full
          hard-drives.
        ";
      };

      options = mkOption {
        default = "";
        example = "--max-freed $((64 * 1024**3))";
        type = types.string;
        description = "
          Options given to <filename>nix-collect-garbage</filename> when the
          garbage collector is run automatically.
        ";
      };

    };
  };


  ###### implementation

  config = {

    services.cron.systemCronJobs = mkIf cfg.automatic (singleton
      "${cfg.dates} root ${config.systemd.package}/bin/systemctl start nix-gc.service");

    systemd.services."nix-gc" =
      { description = "Nix Garbage Collector";
        path  = [ config.environment.nix ];
        script = "exec nix-collect-garbage ${cfg.options}";
      };

  };

}
