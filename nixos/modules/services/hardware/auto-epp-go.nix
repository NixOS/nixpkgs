{ config, lib, pkgs, ... }:
with lib;

let

 cfg = config.services.auto-epp;
 package = pkgs.auto-epp-go;

in {
 options = {

    services.auto-epp = {
      enable = mkEnableOption (lib.mdDoc "auto-epp for amd active pstate");
      batState= mkOption {
        type = types.str;
        default = "power";
        description = lib.mdDoc "energy_performance_preference when on battery";
      };

     acState= mkOption {
        type = types.str;
        default = "balance_performance";
        description = lib.mdDoc "energy_performance_preference when plugged in";
      };

    };

  };

  config = mkIf cfg.enable {

    boot.kernelParams = [
      "amd_pstate=active"
    ];

    environment.etc."auto-epp-go.conf".text = ''
     [Settings]
     epp_state_for_AC=${cfg.acState}
     epp_state_for_BAT=${cfg.batState}
    '';

    systemd.packages = [ package ];

    systemd.services.auto-epp = {
      enable = true;
      after = [ "network.target" "network-online.target"  ];
      description = "auto-epp-go - Automatic EPP Changer for amd-pstate-epp";
      serviceConfig = {
        Type = "simple";
        User = "root";
        ExecStart = "${package}/bin/auto-epp-go";
        Restart = "on-failure";
      };

      wantedBy  = [ "multi-user.target" ];
    };

  };
}
