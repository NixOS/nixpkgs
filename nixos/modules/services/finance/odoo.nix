{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.odoo;
  format = pkgs.formats.ini { };
in
{
  options = {
    services.odoo = {
      enable = lib.mkEnableOption "odoo, an open source ERP and CRM system";

      package = lib.mkPackageOption pkgs "odoo" { };

      addons = lib.mkOption {
        type = with lib.types; listOf package;
        default = [ ];
        example = lib.literalExpression "[ pkgs.odoo_enterprise ]";
        description = "Odoo addons.";
      };

      autoInit = lib.mkEnableOption "automatically initialize the DB";

      autoInitExtraFlags = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        example =
          lib.literalExpression # nix
            ''
              [ "--without-demo=all" ]
            '';
        description = "Extra flags passed to odoo when run for the first time by autoInit";
      };

      settings = lib.mkOption {
        type = format.type;
        default = { };
        description = ''
          Odoo configuration settings. For more details see <https://www.odoo.com/documentation/15.0/administration/install/deploy.html>
        '';
        example = lib.literalExpression ''
          options = {
            db_user = "odoo";
            db_password="odoo";
          };
        '';
      };

      domain = lib.mkOption {
        type = with lib.types; nullOr str;
        description = "Domain to host Odoo with nginx";
        default = null;
      };
    };
  };

  config = lib.mkIf (cfg.enable) (
    let
      cfgFile = format.generate "odoo.cfg" cfg.settings;
    in
    {
      services.nginx = lib.mkIf (cfg.domain != null) {
        upstreams = {
          odoo.servers = {
            "127.0.0.1:8069" = { };
          };

          odoochat.servers = {
            "127.0.0.1:8072" = { };
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

      services.odoo.settings.options =
        {
          data_dir = "/var/lib/private/odoo/data";
          proxy_mode = cfg.domain != null;
        }
        // (lib.optionalAttrs (cfg.addons != [ ]) {
          addons_path = lib.concatMapStringsSep "," lib.escapeShellArg cfg.addons;
        });

      users.users.odoo = {
        isSystemUser = true;
        group = "odoo";
      };
      users.groups.odoo = { };

      systemd.services.odoo = {
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "postgresql.service"
        ];

        # pg_dump
        path = [ config.services.postgresql.package ];

        requires = [ "postgresql.service" ];

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/odoo";
          ExecStartPre = pkgs.writeShellScript "odoo-start-pre.sh" (
            ''
              set -euo pipefail

              cd "$STATE_DIRECTORY"

              # Auto-migrate old deployments
              if [[ -d .local/share/Odoo ]]; then
                echo "pre-start: migrating state directory from $STATE_DIRECTORY/.local/share/Odoo to $STATE_DIRECTORY/data"
                mv .local/share/Odoo ./data
                rmdir .local/share
                rmdir .local
              fi
            ''
            + (lib.optionalString cfg.autoInit ''
              echo "pre-start: auto-init"
              INITIALIZED="${cfg.settings.options.data_dir}/.odoo.initialized"
              if [ ! -e "$INITIALIZED" ]; then
                ${cfg.package}/bin/odoo  --init=INIT --database=odoo --db_user=odoo --stop-after-init ${lib.concatStringsSep " " cfg.autoInitExtraFlags}
                touch "$INITIALIZED"
              fi
            '')
            + "echo pre-start: OK"
          );
          DynamicUser = true;
          User = "odoo";
          StateDirectory = "odoo";
          Environment = [
            "ODOO_RC=${cfgFile}"
          ];
        };
      };

      services.postgresql = {
        enable = true;

        ensureDatabases = [ "odoo" ];
        ensureUsers = [
          {
            name = "odoo";
            ensureDBOwnership = true;
          }
        ];
      };
    }
  );
}
