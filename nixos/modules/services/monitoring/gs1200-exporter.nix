{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gs1200-exporter;
in
{
  options.services.gs1200-exporter = {
    enable = lib.mkEnableOption "gs1200-exporter";

    address = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "IP address or hostname of the GS1200 switch.";
      example = "192.168.1.3";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9934;
      description = "Port on which to expose Prometheus metrics.";
    };

    password = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Password to log in to the GS1200 web interface.
        Use passwordFile instead to avoid storing the password in the Nix store.
      '';
    };

    passwordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file containing the password to log in to the GS1200 web interface.
        This is the recommended option as it avoids storing the password in the Nix store.
        Compatible with sops-nix and agenix.
      '';
      example = "/run/secrets/gs1200-password";
    };

    debug = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable debug logging. Logs are accessible via journalctl -u gs1200-exporter.";
    };

    verbose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable verbose logging. Logs are accessible via journalctl -u gs1200-exporter.";
    };

    json = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Output logs in JSON format. Logs are accessible via journalctl -u gs1200-exporter.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "gs1200-exporter";
      description = "User under which the service runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "gs1200-exporter";
      description = "Group under which the service runs.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.address != "";
        message = "services.gs1200-exporter: address must be set to the IP address or hostname of your GS1200 switch.";
      }
      {
        assertion = (cfg.password == null) != (cfg.passwordFile == null);
        message = "services.gs1200-exporter: exactly one of password or passwordFile must be set.";
      }
    ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      description = "gs1200-exporter service user";
    };

    users.groups.${cfg.group} = { };

    systemd.services.gs1200-exporter = {
      description = "Prometheus exporter for Zyxel GS1200 switches";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        RestartSec = "10s";

        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        CapabilityBoundingSet = "";
      };

      script =
        let
          args = lib.concatStringsSep " " (
            [
              "--address ${cfg.address}"
              "--port ${toString cfg.port}"
            ]
            ++ lib.optional cfg.debug "--debug"
            ++ lib.optional cfg.verbose "--verbose"
            ++ lib.optional cfg.json "--json"
          );
        in
        if cfg.passwordFile != null then
          ''
            export GS1200_PASSWORD=$(cat ${cfg.passwordFile})
            exec ${lib.getExe pkgs.gs1200-exporter} ${args}
          ''
        else
          ''
            export GS1200_PASSWORD=${lib.escapeShellArg cfg.password}
            exec ${lib.getExe pkgs.gs1200-exporter} ${args}
          '';
    };
  };
}
