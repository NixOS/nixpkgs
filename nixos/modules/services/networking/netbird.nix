{
  config,
  lib,
  pkgs,
  ...
}:

let
  kernel = config.boot.kernelPackages;

  cfg = config.services.netbird;
in
{
  meta.maintainers = with lib.maintainers; [ ];
  meta.doc = ./netbird.md;

  options.services.netbird = {
    enable = lib.mkEnableOption "Netbird daemon";
    package = lib.mkPackageOption pkgs "netbird" { };

    tunnels = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, config, ... }:
          {
            options = {
              port = lib.mkOption {
                type = lib.types.port;
                default = 51820;
                description = ''
                  Port for the ${name} netbird interface.
                '';
              };

              environment = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                defaultText = lib.literalExpression ''
                  {
                    NB_CONFIG = "/var/lib/''${stateDir}/config.json";
                    NB_LOG_FILE = "console";
                    NB_WIREGUARD_PORT = builtins.toString port;
                    NB_INTERFACE_NAME = name;
                    NB_DAMEON_ADDR = "/var/run/''${stateDir}"
                  }
                '';
                description = ''
                  Environment for the netbird service, used to pass configuration options.
                '';
              };

              stateDir = lib.mkOption {
                type = lib.types.str;
                default = "netbird-${name}";
                description = ''
                  Directory storing the netbird configuration.
                '';
              };
            };

            config.environment = builtins.mapAttrs (_: lib.mkDefault) {
              NB_CONFIG = "/var/lib/${config.stateDir}/config.json";
              NB_LOG_FILE = "console";
              NB_WIREGUARD_PORT = builtins.toString config.port;
              NB_INTERFACE_NAME = name;
              NB_DAEMON_ADDR = "unix:///var/run/${config.stateDir}/sock";
            };
          }
        )
      );
      default = { };
      description = ''
        Attribute set of Netbird tunnels, each one will spawn a daemon listening on ...
      '';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      # For backwards compatibility
      services.netbird.tunnels.wt0.stateDir = "netbird";
    })

    (lib.mkIf (cfg.tunnels != { }) {
      boot.extraModulePackages = lib.optional (lib.versionOlder kernel.kernel.version "5.6") kernel.wireguard;

      environment.systemPackages = [ cfg.package ];

      networking.dhcpcd.denyInterfaces = lib.attrNames cfg.tunnels;

      systemd.network.networks = lib.mkIf config.networking.useNetworkd (
        lib.mapAttrs' (
          name: _:
          lib.nameValuePair "50-netbird-${name}" {
            matchConfig = {
              Name = name;
            };
            linkConfig = {
              Unmanaged = true;
              ActivationPolicy = "manual";
            };
          }
        ) cfg.tunnels
      );

      systemd.services = lib.mapAttrs' (
        name:
        { environment, stateDir, ... }:
        lib.nameValuePair "netbird-${name}" {
          description = "A WireGuard-based mesh network that connects your devices into a single private network";

          documentation = [ "https://netbird.io/docs/" ];

          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          path = with pkgs; [ openresolv ];

          inherit environment;

          serviceConfig = {
            ExecStart = "${lib.getExe cfg.package} service run";
            Restart = "always";
            RuntimeDirectory = stateDir;
            StateDirectory = stateDir;
            StateDirectoryMode = "0700";
            WorkingDirectory = "/var/lib/${stateDir}";
          };

          unitConfig = {
            StartLimitInterval = 5;
            StartLimitBurst = 10;
          };

          stopIfChanged = false;
        }
      ) cfg.tunnels;
    })
  ];
}
