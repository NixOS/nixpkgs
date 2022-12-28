{ config, lib, ... }:

with lib;

let
  cfg = config.nix.optimise;
in

{

  ###### interface

  options = {

    nix.optimise = {

      automatic = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Automatically run the nix store optimiser at a specific time.";
      };

      dates = mkOption {
        default = ["03:45"];
        type = types.listOf types.str;
        description = lib.mdDoc ''
          Specification (in the format described by
          {manpage}`systemd.time(7)`) of the time at
          which the optimiser will run.
        '';
      };
    };
  };


  ###### implementation

  config = {
    assertions = [
      {
        assertion = cfg.automatic -> config.nix.enable;
        message = ''nix.optimise.automatic requires nix.enable'';
      }
    ];

    systemd.services.nix-optimise = lib.mkIf config.nix.enable
      { description = "Nix Store Optimiser";
        # No point this if the nix daemon (and thus the nix store) is outside
        unitConfig.ConditionPathIsReadWrite = "/nix/var/nix/daemon-socket";
        serviceConfig.ExecStart = "${config.nix.package}/bin/nix-store --optimise";
        startAt = optionals cfg.automatic cfg.dates;
      };

  };

}
