{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.phd;

in

{

  ###### interface

  options = {

    services.phd = {

      enable = mkOption {
        default = false;
        description = "
          Enable daemons for phabricator.
        ";
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.phd = {
      path = [ pkgs.phabricator pkgs.php pkgs.mercurial pkgs.git pkgs.subversion ];

      after = [ "httpd.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.phabricator}/phabricator/bin/phd start";
        ExecStop = "${pkgs.phabricator}/phabricator/bin/phd stop";
        User = "wwwrun";
        RestartSec = "30s";
        Restart = "always";
        StartLimitInterval = "1m";
      };
    };

  };

}
