{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.i2p;
  homeDir = "/var/lib/i2p";
in {
  ###### interface
  options.services.i2p.enable = mkEnableOption (lib.mdDoc "I2P router");

  ###### implementation
  config = mkIf cfg.enable {
    users.users.i2p = {
      group = "i2p";
      description = "i2p User";
      home = homeDir;
      createHome = true;
      uid = config.ids.uids.i2p;
    };
    users.groups.i2p.gid = config.ids.gids.i2p;
    systemd.services.i2p = {
      description = "I2P router with administration interface for hidden services";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "i2p";
        WorkingDirectory = homeDir;
        Restart = "on-abort";
        ExecStart = "${pkgs.i2p}/bin/i2prouter-plain";
      };
    };
  };
}
