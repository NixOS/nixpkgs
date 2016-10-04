{ config, lib, pkgs, ... }:

with lib;

let

  uid = config.ids.uids.squeezelite;
  cfg = config.services.squeezelite;

in {

  ###### interface

  options = {

    services.squeezelite= {

      enable = mkEnableOption "Squeezelite, a software Squeezebox emulator";

      dataDir = mkOption {
        default = "/var/lib/squeezelite";
        type = types.str;
        description = ''
          The directory where Squeezelite stores its name file.
        '';
      };

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
      preStart = "mkdir -p ${cfg.dataDir} && chown -R squeezelite ${cfg.dataDir}";
      serviceConfig = {
        ExecStart = "${pkgs.squeezelite}/bin/squeezelite -N ${cfg.dataDir}/player-name ${cfg.extraArguments}";
        User = "squeezelite";
        PermissionsStartOnly = true;
      };
    };

    users.extraUsers.squeezelite= {
      inherit uid;
      group = "nogroup";
      extraGroups = [ "audio" ];
      description = "Squeezelite user";
      home = "${cfg.dataDir}";
    };

  };

}
