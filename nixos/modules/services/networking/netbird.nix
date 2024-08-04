{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    attrNames
    getExe
    literalExpression
    maintainers
    mapAttrs'
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    nameValuePair
    optional
    versionOlder
    ;

  inherit (lib.types)
    attrsOf
    port
    str
    submodule
    ;

  kernel = config.boot.kernelPackages;

  cfg = config.services.netbird;
in
{
  meta.maintainers = with maintainers; [
    misuzu
  ];
  meta.doc = ./netbird.md;

  options.services.netbird = {
    enable = mkEnableOption "Netbird daemon";
    package = mkPackageOption pkgs "netbird" { };

    tunnels = mkOption {
      type = attrsOf (
        submodule (
          { name, config, ... }:
          {
            options = {
              port = mkOption {
                type = port;
                default = 51820;
                description = ''
                  Port for the ${name} netbird interface.
                '';
              };

              environment = mkOption {
                type = attrsOf str;
                defaultText = literalExpression ''
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

              stateDir = mkOption {
                type = str;
                default = "netbird-${name}";
                description = ''
                  Directory storing the netbird configuration.
                '';
              };
            };

            config.environment = builtins.mapAttrs (_: mkDefault) {
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

  config = mkMerge [
    (mkIf cfg.enable {
      # For backwards compatibility
      services.netbird.tunnels.wt0.stateDir = "netbird";
    })

    (mkIf (cfg.tunnels != { }) {
      boot.extraModulePackages = optional (versionOlder kernel.kernel.version "5.6") kernel.wireguard;

      environment.systemPackages = [ cfg.package ];

      networking.dhcpcd.denyInterfaces = attrNames cfg.tunnels;

      systemd.network.networks = mkIf config.networking.useNetworkd (
        mapAttrs'
          (
            name: _:
            nameValuePair "50-netbird-${name}" {
              matchConfig = {
                Name = name;
              };
              linkConfig = {
                Unmanaged = true;
                ActivationPolicy = "manual";
              };
            }
          )
          cfg.tunnels
      );

      systemd.services =
        mapAttrs'
          (
            name:
            { environment, stateDir, ... }:
            nameValuePair "netbird-${name}" {
              description = "A WireGuard-based mesh network that connects your devices into a single private network";

              documentation = [ "https://netbird.io/docs/" ];

              after = [ "network.target" ];
              wantedBy = [ "multi-user.target" ];

              path = with pkgs; [ openresolv ];

              inherit environment;

              serviceConfig = {
                ExecStart = "${getExe cfg.package} service run";
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
          )
          cfg.tunnels;
    })
  ];
}
