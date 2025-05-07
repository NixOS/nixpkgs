{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.livekit;
  format = pkgs.formats.json { };
in
{
  meta.maintainers = with lib.maintainers; [ quadradical ];
  options.services.livekit = {
    enable = lib.mkEnableOption "the livekit server";
    package = lib.mkPackageOption pkgs "livekit" { };

    keyFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        LiveKit key file holding one or multiple application secrets. Use `livekit-server generate-keys` to generate a random key name and secret.

        The file should have the format `<keyname>: <secret>`.
        Example:
        `lk-jwt-service: f6lQGaHtM5HfgZjIcec3cOCRfiDqIine4CpZZnqdT5cE`

        Individual key/secret pairs need to be passed to clients to connect to this instance.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Opens port range for LiveKit on the firewall.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          port = lib.mkOption {
            type = lib.types.port;
            default = 7880;
            description = "Main TCP port for RoomService and RTC endpoint.";
          };

          rtc = {
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
        LiveKit configuration file expressed in nix.

        For an example configuration, see <https://docs.livekit.io/home/self-hosting/deployment/#configuration>.
        For all possible values, see <https://github.com/livekit/livekit/blob/master/config-sample.yaml>.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [
        cfg.settings.port
      ];
      allowedUDPPortRanges = [
        {
          from = cfg.settings.rtc.port_range_start;
          to = cfg.settings.rtc.port_range_end;
        }
      ];
    };

    systemd.services.livekit = {
      description = "LiveKit SFU server";
      documentation = [ "https://docs.livekit.io" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        LoadCredential = [ "livekit-secrets:${cfg.keyFile}" ];
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe cfg.package)
          "--config=${format.generate "livekit.json" cfg.settings}"
          "--key-file=/run/credentials/livekit.service/livekit-secrets"
        ];
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
