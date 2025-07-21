{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.corteza;
in
{
  options.services.corteza = {
    enable = lib.mkEnableOption "Corteza, a low-code platform";
    package = lib.mkPackageOption pkgs "corteza" { };

    address = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = ''
        IP for the HTTP server.
      '';
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 80;
      description = ''
        Port for the HTTP server.
      '';
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Whether to open ports in the firewall.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "corteza";
      description = "The user to run Corteza under.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "corteza";
      description = "The group to run Corteza under.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf lib.types.str;
        options = {
          HTTP_WEBAPP_ENABLED = lib.mkEnableOption "webapps" // {
            default = true;
            apply = toString;
          };
        };
      };
      default = { };
      description = ''
        Configuration for Corteza, will be passed as environment variables.
        See <https://docs.cortezaproject.org/corteza-docs/2024.9/devops-guide/references/configuration/server.html>.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.settings ? HTTP_ADDR;
        message = "Use `services.corteza.address` and `services.corteza.port` instead.";
      }
    ];

    warnings = lib.optional (!cfg.settings ? DB_DSN) ''
      A database connection string is not set.
      Corteza will create a temporary SQLite database in memory, but it will not persist data.
      For production use, set `services.corteza.settings.DB_DSN`.
    '';

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.corteza = {
      description = "Corteza";
      documentation = [ "https://docs.cortezaproject.org/" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        HTTP_WEBAPP_BASE_DIR = "./webapp";
        HTTP_ADDR = "${cfg.address}:${toString cfg.port}";
      } // cfg.settings;
      path = [ pkgs.dart-sass ];
      serviceConfig = {
        WorkingDirectory = cfg.package;
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${lib.getExe cfg.package} serve-api";
      };
    };

    users = {
      groups.${cfg.group} = { };
      users.${cfg.user} = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    prince213
  ];
}
