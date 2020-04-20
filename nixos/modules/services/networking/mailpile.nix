{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.mailpile;

  hostname = cfg.hostname;
  port = cfg.port;

in

{

  ###### interface

  options = {

    services.mailpile = {
      enable = mkEnableOption "Mailpile the mail client";

      hostname = mkOption {
        default = "localhost";
        description = "Listen to this hostname or ip.";
      };
      port = mkOption {
        default = "33411";
        description = "Listen on this port.";
      };
    };

  };


  ###### implementation

  config = mkIf config.services.mailpile.enable {

    users.users.mailpile =
      { uid = config.ids.uids.mailpile;
        description = "Mailpile user";
        createHome = true;
        home = "/var/lib/mailpile";
      };

    users.groups.mailpile =
      { gid = config.ids.gids.mailpile;
      };

    systemd.services.mailpile =
      {
        description = "Mailpile server.";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "mailpile";
          ExecStart = "${pkgs.mailpile}/bin/mailpile --www ${hostname}:${port} --wait";
          # mixed - first send SIGINT to main process,
          # then after 2min send SIGKILL to whole group if neccessary
          KillMode = "mixed";
          KillSignal = "SIGINT";  # like Ctrl+C - safe mailpile shutdown
          TimeoutSec = 120;  # wait 2min untill SIGKILL
        };
        environment.MAILPILE_HOME = "/var/lib/mailpile/.local/share/Mailpile";
      };

    environment.systemPackages = [ pkgs.mailpile ];

  };

}
