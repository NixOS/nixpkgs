{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.longview;

  runDir = "/run/longview";
  configsDir = "${runDir}/longview.d";

in {
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
        default = "";
        example = "01234567-89AB-CDEF-0123456789ABCDEF";
        description = ''
          Longview API key. To get this, look in Longview settings which
          are found at https://manager.linode.com/longview/.

          Warning: this secret is stored in the world-readable Nix store!
          Use {option}`apiKeyFile` instead.
        '';
      };

      apiKeyFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/longview-api-key";
        description = ''
          A file containing the Longview API key.
          To get this, look in Longview settings which
          are found at https://manager.linode.com/longview/.

          {option}`apiKeyFile` takes precedence over {option}`apiKey`.
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
        default = "";
        description = ''
          The password corresponding to {option}`mysqlUser`.
          Warning: this is stored in cleartext in the Nix store!
          Use {option}`mysqlPasswordFile` instead.
        '';
      };

      mysqlPasswordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/dbpassword";
        description = ''
          A file containing the password corresponding to {option}`mysqlUser`.
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
        serviceConfig.PIDFile = "${runDir}/longview.pid";
        serviceConfig.ExecStart = "${pkgs.longview}/bin/longview";
        preStart = ''
          umask 077
          mkdir -p ${configsDir}
        '' + (optionalString (cfg.apiKeyFile != null) ''
          cp --no-preserve=all "${cfg.apiKeyFile}" ${runDir}/longview.key
        '') + (optionalString (cfg.apacheStatusUrl != "") ''
          cat > ${configsDir}/Apache.conf <<EOF
          location ${cfg.apacheStatusUrl}?auto
          EOF
        '') + (optionalString (cfg.mysqlUser != "" && cfg.mysqlPasswordFile != null) ''
          cat > ${configsDir}/MySQL.conf <<EOF
          username ${cfg.mysqlUser}
          password `head -n1 "${cfg.mysqlPasswordFile}"`
          EOF
        '') + (optionalString (cfg.nginxStatusUrl != "") ''
          cat > ${configsDir}/Nginx.conf <<EOF
          location ${cfg.nginxStatusUrl}
          EOF
        '');
      };

    warnings = let warn = k: optional (cfg.${k} != "")
                 "config.services.longview.${k} is insecure. Use ${k}File instead.";
               in concatMap warn [ "apiKey" "mysqlPassword" ];

    assertions = [
      { assertion = cfg.apiKeyFile != null;
        message = "Longview needs an API key configured";
      }
    ];

    # Create API key file if not configured.
    services.longview.apiKeyFile = mkIf (cfg.apiKey != "")
      (mkDefault (toString (pkgs.writeTextFile {
        name = "longview.key";
        text = cfg.apiKey;
      })));

    # Create MySQL password file if not configured.
    services.longview.mysqlPasswordFile = mkDefault (toString (pkgs.writeTextFile {
      name = "mysql-password-file";
      text = cfg.mysqlPassword;
    }));
  };
}
