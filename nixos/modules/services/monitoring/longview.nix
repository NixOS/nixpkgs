{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.longview;

  pidFile = "/run/longview.pid";

  apacheConf =  ''
    #location http://127.0.0.1/server-status?auto
  '';
  mysqlConf = ''
    #username root
    #password example_password
  '';
  nginxConf = ''
    #location http://127.0.0.1/nginx_status
  '';

in

{
  options = {

    services.longview = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, system metrics will be sent to Linode LongView.
        '';
      };

      apiKey = mkOption {
        type = types.str;
        description = ''
          Longview API key. To get this, look in Longview settings which
          are found at https://manager.linode.com/longview/.
        '';
      };

    };

  };

  config = mkIf cfg.enable {
    systemd.services.longview =
      { description = "Longview Metrics Collection";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "forking";
        serviceConfig.ExecStop = "-${pkgs.coreutils}/bin/kill -TERM $MAINPID";
        serviceConfig.ExecReload = "-${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        serviceConfig.PIDFile = pidFile;
        serviceConfig.ExecStart = "${pkgs.longview}/bin/longview";
      };

    environment.etc."linode/longview.key" = {
      mode = "0400";
      text = cfg.apiKey;
    };
    environment.etc."linode/longview.d/Apache.conf" = {
      mode = "0400";
      text = apacheConf;
    };
    environment.etc."linode/longview.d/MySQL.conf" = {
      mode = "0400";
      text = mysqlConf;
    };
    environment.etc."linode/longview.d/Nginx.conf" = {
      mode = "0400";
      text = nginxConf;
    };
  };
}
