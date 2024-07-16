{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.odoo;
  format = pkgs.formats.ini {};
in
{
  options = {
    services.odoo = {
      enable = mkEnableOption "odoo, an open source ERP and CRM system";

      package = mkPackageOption pkgs "odoo" { };

      addons = mkOption {
        type = with types; listOf package;
        default = [];
        example = literalExpression "[ pkgs.odoo_enterprise ]";
        description = "Odoo addons.";
      };

      autoInit = mkEnableOption "automatically initialize the DB";

      settings = mkOption {
        type = format.type;
        default = {};
        description = ''
          Odoo configuration settings. For more details see <https://www.odoo.com/documentation/15.0/administration/install/deploy.html>
        '';
        example = literalExpression ''
          options = {
            db_user = "odoo";
            db_password="odoo";
          };
        '';
      };

      domain = mkOption {
        type = with types; nullOr str;
        description = "Domain to host Odoo with nginx";
        default = null;
      };
    };
  };

  config = mkIf (cfg.enable) (let
    cfgFile = format.generate "odoo.cfg" cfg.settings;
  in {
    services.nginx = mkIf (cfg.domain != null) {
      upstreams = {
        odoo.servers = {
          "127.0.0.1:8069" = {};
        };

        odoochat.servers = {
          "127.0.0.1:8072" = {};
        };
      };

      virtualHosts."${cfg.domain}" = {
        extraConfig = ''
          proxy_read_timeout 720s;
          proxy_connect_timeout 720s;
          proxy_send_timeout 720s;

          proxy_set_header X-Forwarded-Host $host;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Real-IP $remote_addr;
        '';

        locations = {
          "/longpolling" = {
            proxyPass = "http://odoochat";
          };

          "/" = {
            proxyPass = "http://odoo";
            extraConfig = ''
              proxy_redirect off;
            '';
          };
        };
      };
    };

    services.odoo.settings.options = {
      proxy_mode = cfg.domain != null;
    } // (lib.optionalAttrs (cfg.addons != []) {
      addons_path = concatMapStringsSep "," escapeShellArg cfg.addons;
    });

    users.users.odoo = {
      isSystemUser = true;
      group = "odoo";
    };
    users.groups.odoo = {};

    systemd.services.odoo = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "postgresql.service" ];

      # pg_dump
      path = [ config.services.postgresql.package ];

      requires = [ "postgresql.service" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/odoo";
        DynamicUser = true;
        User = "odoo";
        StateDirectory = "odoo";
        Environment = [
          "HOME=%S/odoo"
          "ODOO_RC=${cfgFile}"
        ];
      } // (lib.optionalAttrs cfg.autoInit {
        ExecStartPre = "${cfg.package}/bin/odoo --init=INIT --database=odoo --db_user=odoo --stop-after-init";
      });
    };

    services.postgresql = {
      enable = true;

      ensureDatabases = [ "odoo" ];
      ensureUsers = [{
        name = "odoo";
        ensureDBOwnership = true;
      }];
    };
  });
}
