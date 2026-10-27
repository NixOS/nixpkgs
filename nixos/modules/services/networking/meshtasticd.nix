{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.meshtasticd;
  format = pkgs.formats.yaml { };
  configFile = format.generate "config.yaml" cfg.settings;
in
{
  options.services.meshtasticd = {
    enable = lib.mkEnableOption "Meshtastic daemon";
    package = lib.mkPackageOption pkgs "meshtasticd" { };

    user = lib.mkOption {
      default = "meshtasticd";
      description = "User meshtasticd runs as.";
      type = lib.types.str;
    };

    group = lib.mkOption {
      default = "meshtasticd";
      description = "Group meshtasticd runs as.";
      type = lib.types.str;
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 4403;
      description = "Port to listen on";
    };

    settings = lib.mkOption {
      type = format.type;
      example = lib.literalExpression ''
        Lora = {
          Module = "auto";
        };
        Webserver = {
          Port = 9443;
          RootPath = pkgs.meshtastic-web;
        };
        General = {
          MaxNodes = 200;
          MaxMessageQueue = 100;
          MACAddressSource = "eth0";
        };
      '';
      description = ''
        The Meshtastic configuration file.

        An example of configuration can be found at <https://github.com/meshtastic/firmware/blob/develop/bin/config-dist.yaml>
      '';
    };

    dataDir = lib.mkOption {
      default = "/var/lib/meshtasticd";
      type = lib.types.path;
      description = ''
        The data directory.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Creation of the `meshtasticd` privilege user.
    users = {
      users = lib.mkIf (cfg.user == "meshtasticd") {
        meshtasticd = {
          home = cfg.dataDir;
          description = "meshtasticd-daemon privilege user";
          group = cfg.group;
          isSystemUser = true;
          extraGroups = [
            "spi"
            "gpio"
          ];
        };
      };
      groups = lib.mkIf (cfg.group == "meshtasticd") {
        meshtasticd = { };
        # These groups are required for udev rules to work properly.
        spi = { };
        gpio = { };
      };
    };

    # The `meshtasticd` package provides udev rules.
    services.udev.packages = [
      cfg.package
    ];

    # Creation of the `meshtasticd` service.
    # Based on the official meshtasticd service file: https://github.com/meshtastic/firmware/blob/develop/bin/meshtasticd.service
    systemd.services.meshtasticd = {
      description = "Meshtastic Native Daemon";
      after = [
        "network-online.target"
        "network.target"
      ];
      wants = [
        "network-online.target"
        "network.target"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "simple";
        StateDirectory = "meshtasticd";
        AmbientCapabilities = [
          "CAP_NET_BIND_SERVICE"
        ];
        ExecStart = "${lib.getExe cfg.package} --port=${toString cfg.port} --fsdir=${cfg.dataDir} --config=${configFile} --verbose";
        Restart = "always";
        RestartSec = "3";
      };
    };
  };
}
