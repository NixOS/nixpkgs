{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.livekit.ingress;
  format = pkgs.formats.yaml { };
in
{
  meta.maintainers = with lib.maintainers; [ k900 ];
  options.services.livekit.ingress = {
    enable = lib.mkEnableOption "the livekit ingress service";
    package = lib.mkPackageOption pkgs "livekit-ingress" { };

    openFirewall = {
      rtc = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open WebRTC ports in the firewall.";
      };

      rtmp = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open RTMP port in the firewall.";
      };

      whip = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open WHIP port in the firewall.";
      };
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          rtmp_port = lib.mkOption {
            type = lib.types.port;
            default = 1935;
            description = "TCP port for RTMP connections";
          };

          whip_port = lib.mkOption {
            type = lib.types.port;
            default = 8080;
            description = "TCP port for WHIP connections";
          };

          rtc_config = {
            port_range_start = lib.mkOption {
              type = lib.types.int;
              default = 50000;
              description = "Start of UDP port range for WebRTC";
            };

            port_range_end = lib.mkOption {
              type = lib.types.int;
              default = 51000;
              description = "End of UDP port range for WebRTC";
            };

            use_external_ip = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                When set to true, attempts to discover the host's public IP via STUN.
                This is useful for cloud environments such as AWS & Google where hosts have an internal IP that maps to an external one.
              '';
            };
          };
        };
      };
      default = { };
      description = ''
        LiveKit Ingress configuration.

        See <https://github.com/livekit/ingress?tab=readme-ov-file#config> for possible options.
      '';
      example = {
        prometheus_port = 9039;
        cpu_cost = {
          rtmp_cpu_cost = 3.0;
          whip_cpu_cost = 1.0;
        };
      };
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Environment file as defined in {manpage}`systemd.exec(5)` passed to the service.

        Use this to specify `LIVEKIT_API_KEY` and `LIVEKIT_API_SECRET`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = lib.mkMerge [
        (lib.mkIf cfg.openFirewall.rtmp [ cfg.settings.rtmp_port ])
        (lib.mkIf cfg.openFirewall.whip [ cfg.settings.whip_port ])
      ];
      allowedUDPPortRanges = lib.mkIf cfg.openFirewall.rtc [
        {
          from = cfg.settings.rtc_config.port_range_start;
          to = cfg.settings.rtc_config.port_range_end;
        }
      ];
    };

    systemd.services.livekit-ingress = {
      description = "LiveKit Ingress server";
      documentation = [ "https://docs.livekit.io/home/self-hosting/ingress/" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe cfg.package)
          "--config=${format.generate "ingress.yaml" cfg.settings}"
        ];
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        ProtectHome = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        Restart = "on-failure";
        RestartSec = 5;
        UMask = "077";
      };
    };
  };
}
