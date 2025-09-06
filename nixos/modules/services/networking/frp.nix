{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.frp;
  settingsFormat = pkgs.formats.toml { };
  configFile =
    if cfg.settingsFile != null then
      cfg.settingsFile
    else
      settingsFormat.generate "frp.toml" cfg.settings;
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
          This can not be set with `settingsFile` at the same time.
        '';
        example = {
          serverAddr = "x.x.x.x";
          serverPort = 7000;
        };
      };

      settingsFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          A file contains frp configuration. This option takes the path of a file.
          The path is **unchecked** to keep pure.
          see the example of [client](https://github.com/fatedier/frp/blob/dev/conf/frpc_full_example.toml)
          or [server](https://github.com/fatedier/frp/blob/dev/conf/frps_full_example.toml) on github.
          This can not be set with `settings` at the same time.
        '';
        example = "/run/configs/myconfig.toml";
      };
    };
  };

  config =
    let
      serviceCapability = lib.optionals isServer [ "CAP_NET_BIND_SERVICE" ];
      executableFile = if isClient then "frpc" else "frps";
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = !(cfg.settingsFile != null && cfg.settings != { });
          message = "Cannot set `settingsFile` when `settings` is set";
        }
        {
          assertion = !(cfg.settingsFile == null && cfg.settings == { });
          message = "One of `settingsFile` or `settings` must be set";
        }
      ];

      systemd.services = {
        frp = {
          wants = lib.optionals isClient [ "network-online.target" ];
          after = if isClient then [ "network-online.target" ] else [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          description = "A fast reverse proxy frp ${cfg.role}";
          serviceConfig = {
            Type = "simple";
            Restart = "on-failure";
            RestartSec = 15;
            ExecStart = "${cfg.package}/bin/${executableFile} --strict_config -c ${configFile}";
            StateDirectoryMode = lib.optionalString isServer "0700";
            DynamicUser = true;
            # Hardening
            UMask = lib.optionalString isServer "0007";
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
          };
        };
      };
    };

  meta.maintainers = with lib.maintainers; [ zaldnoay ];
}
