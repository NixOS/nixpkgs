{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.services.frp;
  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "frp.toml" cfg.settings;
  isClient = (cfg.role == "client");
  isServer = (cfg.role == "server");
in
{
  options = {
    services.frp = {
      enable = lib.mkEnableOption "frp";

      package = lib.mkPackageOption pkgs "frp" { };

      role = lib.mkOption {
        type = lib.types.enum [
          "server"
          "client"
        ];
        description = ''
          The frp consists of `client` and `server`. The server is usually
          deployed on the machine with a public IP address, and
          the client is usually deployed on the machine
          where the Intranet service to be penetrated resides.
        '';
      };

      settings = lib.mkOption {
        type = settingsFormat.type;
        default = { };
        description = ''
          Frp configuration, for configuration options
          see the example of [client](https://github.com/fatedier/frp/blob/dev/conf/frpc_full_example.toml)
          or [server](https://github.com/fatedier/frp/blob/dev/conf/frps_full_example.toml) on github.
        '';
        example = {
          serverAddr = "x.x.x.x";
          serverPort = 7000;
        };
      };
    };
  };

  config =
    let
      serviceCapability = lib.optionals isServer [ "CAP_NET_BIND_SERVICE" ];
      executableFile = if isClient then "frpc" else "frps";
    in
    lib.mkIf cfg.enable {
      systemd.services = {
        frp = {
          wants = lib.optionals isClient [ "network-online.target" ];
          after = if isClient then [ "network-online.target" ] else [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          description = "A fast reverse proxy frp ${cfg.role}";
          serviceConfig =
            {
              Type = "simple";
              Restart = "on-failure";
              RestartSec = 15;
              ExecStart = "${cfg.package}/bin/${executableFile} --strict_config -c ${configFile}";
              DynamicUser = true;
              # Hardening
              CapabilityBoundingSet = serviceCapability;
              AmbientCapabilities = serviceCapability;
              PrivateDevices = true;
              ProtectHostname = true;
              ProtectClock = true;
              ProtectKernelTunables = true;
              ProtectKernelModules = true;
              ProtectKernelLogs = true;
              ProtectControlGroups = true;
              RestrictAddressFamilies = [
                "AF_INET"
                "AF_INET6"
              ]
              ++ lib.optionals isClient [ "AF_UNIX" ];
              LockPersonality = true;
              MemoryDenyWriteExecute = true;
              RestrictRealtime = true;
              RestrictSUIDSGID = true;
              PrivateMounts = true;
              SystemCallArchitectures = "native";
              SystemCallFilter = [ "@system-service" ];
            }
            // lib.optionalAttrs isServer {
              StateDirectory = "frp";
              StateDirectoryMode = "0700";
              UMask = "0007";
            };
        };
      };
    };

  meta.maintainers = with lib.maintainers; [ zaldnoay ];
}
