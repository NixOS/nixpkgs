{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.oxidns;

  yaml = pkgs.formats.yaml { };

  pluginSubmodule = lib.types.submodule {
    options = {
      tag = lib.mkOption {
        type = lib.types.str;
        description = "Unique identifier for this plugin instance.";
      };
      type = lib.mkOption {
        type = lib.types.str;
        description = "Plugin type, e.g. forward, domain_set, udp_server.";
      };
      args = lib.mkOption {
        type = lib.types.anything;
        default = { };
        description = "Plugin-specific arguments, passed through to YAML verbatim.";
      };
    };
  };

  configFile = yaml.generate "oxidns.yaml" cfg.settings;
in
{
  options.services.oxidns = {
    enable = lib.mkEnableOption "OxiDNS";

    package = lib.mkPackageOption pkgs "oxidns" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = yaml.type;

        options = {
          plugins = lib.mkOption {
            type = lib.types.listOf pluginSubmodule;
            default = [ ];
            description = ''
              Ordered list of plugin instances.
            '';
          };
        };
      };
      default = { };
      description = ''
        OxiDNS configuration. See the [OxiDNS documentation](https://github.com/svenshi/oxidns) for the full configuration schema.
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      readOnly = true;
      description = "Generated YAML configuration path.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.oxidns.configFile = configFile;

    systemd.services.oxidns = {
      description = "OxiDNS DNS engine";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        ExecStartPre = "${cfg.package}/bin/oxidns check -c ${cfg.configFile}";
        ExecStart = "${cfg.package}/bin/oxidns start -c ${cfg.configFile}";
        WorkingDirectory = "%S/oxidns";
        Restart = "on-failure";
        RestartSec = 5;

        DynamicUser = true;

        StateDirectory = "oxidns";
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];

        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
          "AF_NETLINK"
        ];
      };
    };
  };
}
