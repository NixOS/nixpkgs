# NixOS module for Freenet daemon

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.freenet;
  varDir = "/var/lib/freenet";

in

{

  ### configuration

  options = {

    services.freenet = {

      enable = mkOption {
        type = types.uniq types.bool;
        default = false;
        description = "Enable the Freenet daemon";
      };

      nice = mkOption {
        type = types.uniq types.int;
        default = 10;
        description = "Set the nice level for the Freenet daemon";
      };

    };

  };

  ### implementation

  config = mkIf cfg.enable {

    systemd.services.freenet = {
      description = "Freenet daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.freenet}/bin/freenet";
      serviceConfig.User = "freenet";
      serviceConfig.UMask = "0007";
      serviceConfig.WorkingDirectory = varDir;
      serviceConfig.Nice = cfg.nice;
    };

    users.extraUsers.freenet = {
      group = "freenet";
      description = "Freenet daemon user";
      home = varDir;
      createHome = true;
      uid = config.ids.uids.freenet;
    };

    users.extraGroups.freenet.gid = config.ids.gids.freenet;
  };

}
