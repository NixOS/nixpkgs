{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.longview;

  pidFile = "/run/longview.pid";

  apacheConf = optionalString (cfg.apacheStatusUrl != "") ''
    location ${cfg.apacheStatusUrl}?auto
  '';
  mysqlConf = optionalString (cfg.mysqlUser != "") ''
    username ${cfg.mysqlUser}
    password ${cfg.mysqlPassword}
  '';
  nginxConf = optionalString (cfg.nginxStatusUrl != "") ''
    location ${cfg.nginxStatusUrl}
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
        example = "01234567-89AB-CDEF-0123456789ABCDEF";
        description = ''
          Longview API key. To get this, look in Longview settings which
          are found at https://manager.linode.com/longview/.
        '';
      };

      apacheStatusUrl = mkOption {
        type = types.str;
        default = "";
        example = "http://127.0.0.1/server-status";
        description = ''
          The Apache status page URL. If provided, Longview will
          gather statistics from this location. This requires Apache
          mod_status to be loaded and enabled.
        '';
      };

      nginxStatusUrl = mkOption {
        type = types.str;
        default = "";
        example = "http://127.0.0.1/nginx_status";
        description = ''
          The Nginx status page URL. Longview will gather statistics
          from this URL. This requires the Nginx stub_status module to
          be enabled and configured at the given location.
        '';
      };

      mysqlUser = mkOption {
        type = types.str;
        default = "";
        description = ''
          The user for connecting to the MySQL database. If provided,
          Longview will connect to MySQL and collect statistics about
          queries, etc. This user does not need to have been granted
          any extra privileges.
        '';
      };

      mysqlPassword = mkOption {
        type = types.str;
        description = ''
          The password corresponding to mysqlUser.  Warning: this is
          stored in cleartext in the Nix store!
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
