{
  pkgs,
  lib,
  ...
}:

{ config, ... }:

let
  format = pkgs.formats.toml { };

  cfg = config.services.iroh-relay;
in
{
  options.services.iroh-relay = {
    enable = lib.mkEnableOption "iroh-relay";

    package = lib.mkPackageOption pkgs "iroh-relay" { };

    settings = {
      dev_mode = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      ssl = {
        certificate_path = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };

        private_key_path = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
      };
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "iroh-relay";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "iroh-relay";
    };

    logLevel = lib.mkOption {
      type = lib.types.str;
      default = "info";
      description = ''
        The log level for the firezone application. See
        [RUST_LOG](https://docs.rs/env_logger/latest/env_logger/#enabling-logging)
        for the format.
      '';
    };

    openHttpPort = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    openQuicPort = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = "${cfg.group}";
    };

    users.groups."${cfg.group}" = { };

    networking.firewall.allowedTCPPorts =
      (lib.optionals cfg.openHttpPort [ 3340 ]) ++ (lib.optionals cfg.openQuicPort [ 7824 ]);

    systemd.services.iroh-relay = {
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig =
        let
          devFlag = lib.optionalString cfg.settings.dev_mode "--dev";

          configFile = format.generate "config.toml" (
            lib.filterAttrsRecursive (_: v: v != null) cfg.settings
          );
        in
        {
          Type = "simple";
          Environment = [
            "RUST_LOG=${cfg.logLevel}"
          ];
          ExecStart = "${pkgs.lib.getExe cfg.package} --config-path=${configFile} ${devFlag}";

          User = "${cfg.user}";
          Group = "${cfg.group}";

          RuntimeDirectory = "iroh-relay";
          StateDirectory = "iroh-relay";
          ConfigurationDirectory = "iroh-relay";

          PrivateTmp = true;
          PrivateDevices = true;
          PrivateIPC = true;
          ProtectControlGroups = true;
          RemoveIPC = true;

          SystemCallFilter = "@system-service";
          SystemCallErrorNumber = "EPERM";
        };
    };
  };
}
