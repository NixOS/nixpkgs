{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.autobrr;
  configFormat = pkgs.formats.toml { };
  configFile = configFormat.generate "autobrr.toml" cfg.settings;
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "autobrr"
      "secretFile"
    ] "autobrr no longer uses a session secret since version 1.82.0.")
  ];

  options = {
    services.autobrr = {
      enable = lib.mkEnableOption "Autobrr";

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the Autobrr web interface.";
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = configFormat.type;
          options = {
            host = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1";
              description = "The host address autobrr listens on.";
            };

            port = lib.mkOption {
              type = lib.types.port;
              default = 7474;
              description = "The port autobrr listens on.";
            };

            checkForUpdates = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether autobrr needs to check for updates.";
            };
          };
        };
        default = { };
        example = {
          port = 7654;
          logLevel = "DEBUG";
        };
        description = ''
          Autobrr configuration options.

          Refer to <https://autobrr.com/configuration/autobrr>
          for a full list.
        '';
      };

      package = lib.mkPackageOption pkgs "autobrr" { };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      tmpfiles.settings = {
        "10-autobrr" = {
          # DynamicUser uses /var/lib/private/
          "/var/lib/private/autobrr/config.toml"."L+" = {
            argument = "${configFile}";
          };
        };
      };

      services.autobrr = {
        description = "Autobrr";
        after = [
          "syslog.target"
          "network-online.target"
        ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [ configFile ];

        serviceConfig = {
          Type = "simple";
          DynamicUser = true;
          StateDirectory = "autobrr";
          ExecStart = "${lib.getExe cfg.package} --config %S/autobrr";
          Restart = "on-failure";
        };
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.settings.port ]; };
  };

  meta.maintainers = with lib.maintainers; [ av-gal ];
}
