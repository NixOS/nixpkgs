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
  meta.maintainers = with lib.maintainers; [ DerGrumpf ];

  options.services.gs1200-exporter = {
    enable = lib.mkEnableOption "gs1200-exporter";

    address = lib.mkOption {
      type = lib.types.str;
      description = "IP address or hostname of the GS1200 switch.";
      example = "192.168.1.3";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9934;
      description = "Port on which to expose Prometheus metrics.";
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
  };

  config = lib.mkIf cfg.enable {

    systemd.services.gs1200-exporter = {
      description = "Prometheus exporter for Zyxel GS1200 switches";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        Restart = "always";

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
        ''
          export GS1200_PASSWORD=$(cat ${cfg.passwordFile})
          exec ${lib.getExe pkgs.gs1200-exporter} ${args}
        '';
    };
  };
}
