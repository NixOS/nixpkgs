{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.frp;
  settingsFormat = pkgs.formats.toml { };
  enabledInstances = lib.filterAttrs (name: conf: conf.enable) cfg.instances;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "frp" "enable" ]
      [ "services" "frp" "instances" "" "enable" ]
    )
    (lib.mkRenamedOptionModule [ "services" "frp" "role" ] [ "services" "frp" "instances" "" "role" ])
    (lib.mkRenamedOptionModule
      [ "services" "frp" "settings" ]
      [ "services" "frp" "instances" "" "settings" ]
    )
  ];

  options = {
    services.frp = {
      instances = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "frp";

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
          }
        );
        default = { };
        description = ''
          Frp instances.
        '';
      };

      package = lib.mkPackageOption pkgs "frp" { };
    };
  };

  config = lib.mkIf (enabledInstances != { }) {
    systemd.services = lib.mapAttrs' (
      instance: options:
      let
        serviceName = "frp" + lib.optionalString (instance != "") ("-" + instance);
        configFile = settingsFormat.generate "${serviceName}.toml" options.settings;
        isClient = (options.role == "client");
        isServer = (options.role == "server");
        serviceCapability = lib.optionals isServer [ "CAP_NET_BIND_SERVICE" ];
        executableFile = if isClient then "frpc" else "frps";
      in
      lib.nameValuePair serviceName {
        wants = lib.optionals isClient [ "network-online.target" ];
        after = if isClient then [ "network-online.target" ] else [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        description = "A fast reverse proxy frp ${options.role} for instance ${instance}";
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
          ] ++ lib.optionals isClient [ "AF_UNIX" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          PrivateMounts = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" ];
        };
      }
    ) enabledInstances;
  };

  meta.maintainers = with lib.maintainers; [ zaldnoay ];
}
