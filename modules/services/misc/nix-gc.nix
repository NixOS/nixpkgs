{ config, pkgs, ... }:

with pkgs.lib;

let
  nix = config.environment.nix;
  cfg = config.nix.gc;
in

{

  ###### interface

  options = {
    nix.gc = {

      automatic = mkOption {
        default = false;
        example = true;
        description = "
          Automatically run the garbage collector at specified dates.
        ";
      };

      dates = mkOption {
        default = "15 03 * * *";
        description = "
          Run the garbage collector at specified dates to avoid full
          hard-drives.
        ";
      };

      options = mkOption {
        default = "";
        example = "--max-freed $((64 * 1024**3))";
        description = "
          Options given to <filename>nix-collect-garbage</filename> when the
          garbage collector is run automatically.
        ";
      };

    };
  };


  ###### implementation

  config = mkIf cfg.automatic {
    services.cron.systemCronJobs = [
      "${cfg.dates} root ${nix}/bin/nix-collect-garbage ${cfg.options} > /var/log/gc.log 2>&1"
    ];
  };

}
