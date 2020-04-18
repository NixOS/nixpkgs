{ config, lib, pkgs, ... }:

with lib;

let
  dataDir = "/var/lib/squeezelite";
  cfg = config.services.squeezelite;

in {

  ###### interface

  options = {

    services.squeezelite= {

      enable = mkEnableOption "Squeezelite, a software Squeezebox emulator";

      extraArguments = mkOption {
        default = "";
        type = types.str;
        description = ''
          Additional command line arguments to pass to Squeezelite.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.squeezelite= {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "sound.target" ];
      description = "Software Squeezebox emulator";
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.squeezelite}/bin/squeezelite -N ${dataDir}/player-name ${cfg.extraArguments}";
        StateDirectory = builtins.baseNameOf dataDir;
        SupplementaryGroups = "audio";
      };
    };

  };

}
