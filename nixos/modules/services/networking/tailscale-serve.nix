{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.tailscale.serve;
  settingsFormat = pkgs.formats.json { };

  # Build the serve config structure with svc: prefix on service names
  serveConfig = {
    version = "0.0.1";
    services = lib.mapAttrs' (
      name: serviceCfg:
      lib.nameValuePair "svc:${name}" (
        {
          endpoints = serviceCfg.endpoints;
        }
        // lib.optionalAttrs (serviceCfg.advertised != null) {
          inherit (serviceCfg) advertised;
        }
      )
    ) cfg.services;
  };

  configFile =
    if cfg.configFile != null then
      cfg.configFile
    else
      settingsFormat.generate "tailscale-serve-config.json" serveConfig;
in
{
  meta.maintainers = with lib.maintainers; [
    bouk
  ];

  options.services.tailscale.serve = {
    enable = lib.mkEnableOption "Tailscale Serve configuration";

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a Tailscale Serve configuration file in JSON format.
        If set, this takes precedence over {option}`services.tailscale.serve.services`.

        See <https://tailscale.com/kb/1589/tailscale-services-configuration-file> for the configuration format.
      '';
      example = "/run/secrets/tailscale-serve.json";
    };

    services = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            endpoints = lib.mkOption {
              type = lib.types.attrsOf lib.types.str;
              description = ''
                Map of incoming traffic patterns to local targets.

                Keys should be in the format `<protocol>:<port>` or `<protocol>:<port-range>`.
                Currently only `tcp` protocol is supported.

                Values should be in the format `<protocol>://<host:port>` where protocol
                is `http`, `https`, or `tcp`.
              '';
              example = {
                "tcp:443" = "https://localhost:443";
                "tcp:8080" = "http://localhost:8080";
              };
            };

            advertised = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = null;
              description = ''
                Whether the service should accept new connections.
                Defaults to `true` when not specified.
              '';
            };
          };
        }
      );
      default = { };
      description = ''
        Services to configure for Tailscale Serve.

        Each attribute name should be the service name (without the `svc:` prefix).
        The `svc:` prefix will be added automatically.

        See <https://tailscale.com/kb/1589/tailscale-services-configuration-file> for details.
      '';
      example = lib.literalExpression ''
        {
          web-server = {
            endpoints = {
              "tcp:443" = "https://localhost:443";
            };
          };
          api = {
            endpoints = {
              "tcp:8080" = "http://localhost:8080";
            };
            advertised = true;
          };
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.tailscale.enable;
        message = "services.tailscale.serve requires services.tailscale.enable to be true";
      }
      {
        assertion = cfg.configFile != null || cfg.services != { };
        message = "services.tailscale.serve requires either configFile or services to be set";
      }
    ];

    systemd.services.tailscale-serve = {
      description = "Tailscale Serve Configuration";

      after = [
        "tailscaled.service"
        "tailscaled-autoconnect.service"
        "tailscaled-set.service"
      ];
      wants = [ "tailscaled.service" ];
      wantedBy = [ "multi-user.target" ];

      restartTriggers = [ configFile ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${lib.getExe config.services.tailscale.package} serve set-config --all ${configFile}";
      };
    };
  };
}
