{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.labgrid.exporter;

  resourcesConfigFile = lib.generators.toYAML { } cfg.resources;
in
{
  meta = {
    maintainers = with lib.maintainers; [
      aiyion
      emantor
    ];
  };

  options = {
    services.labgrid.exporter = {
      enable = lib.mkEnableOption "Labgrid Exporter";

      package = lib.mkPackageOption pkgs [ "python3Packages" "labgrid" ] { };

      coordinatorAddress = lib.mkOption {
        default = "[::1]";
        type = lib.types.str;
        description = "Address of the labgrid coordinator.";
      };

      coordinatorPort = lib.mkOption {
        default = 20408;
        type = lib.types.port;
        description = "Coordinator port to connect to.";
      };

      debug = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to enable debug mode.
        '';
      };

      extraGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "dialout" ];
        example = [
          "adbusers"
          "dialout"
        ];
        description = ''
          Additional groups for the systemd service.
        '';
      };

      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [
          pkgs.ser2net
          pkgs.microcom
        ];
        defaultText = lib.literalExpression "[ pkgs.ser2net pkgs.microcom ]";
        description = "Extra packages available to the labgrid exporter.";
        example = lib.literalExpression "[ pkgs.ser2net pkgs.usbsdmux ]";
      };

      isolated = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to enable isolated mode (always request SSH forwards).
        '';
      };

      name = lib.mkOption {
        default = "";
        type = lib.types.str;
        description = "public name of this exporter (defaults to the system hostname)";
      };

      hostname = lib.mkOption {
        default = "";
        type = lib.types.str;
        description = "hostname (or IP) published for accessing resources (defaults to the system hostname)";
      };

      useFQDN = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to use the FQDN as announced hostname.
        '';
      };

      resources = lib.mkOption {
        type = with lib.types; attrsOf anything;
        default = { };
        description = ''
          Structural resources.yaml configuration.
          Refer to <ihttps://labgrid.readthedocs.io/en/latest/getting_started.html#exporter>
          for details.
        '';
        example = lib.literalExpression ''
          {
            example-group = {
              location = "example-location";
              USBSerialPort = {
                match = {
                  ID_SERIAL_SHORT = "P-00-00682";
                };
              };
              NetworkPowerPort = {
                model = "netio";
                host = "netio1";
                index = 3;
              };
            };
            example-group-2 = {
              USBSerialPort = {
                match = {
                  ID_SERIAL_SHORT = "KSLAH2341J";
                };
              };
            };
          }
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # hostname and fqdn must not both be set
    assertions = [
      {
        assertion = !cfg.useFQDN || "${cfg.hostname}" != "";
        message = "The options services.labgrid.exporter.hostname and services.labgrid.exporter.useFQDN are mutually exclusive.";
      }
    ];

    environment.etc."labgrid/exporter/resources.yml".text = resourcesConfigFile;

    systemd.tmpfiles = {
      rules = [
        "d /var/cache/labgrid	1775	root	users	2d"
      ];
    };

    systemd.services.labgrid-exporter = {
      after = [ "network-online.target" ];
      description = "Labgrid Exporter";
      path = cfg.extraPackages;
      serviceConfig = {
        Environment = ''"PYTHONUNBUFFERED=1"'';
        ExecStart = ''
          ${lib.getBin cfg.package}/bin/labgrid-exporter \
          ${lib.optionalString cfg.debug "--debug"} \
          ${lib.optionalString cfg.isolated "--isolated"} \
          --coordinator ${cfg.coordinatorAddress}:${toString cfg.coordinatorPort} \
          ${lib.optionalString (cfg.name != "") "--name ${cfg.name}"} \
          ${lib.optionalString (cfg.hostname != "") "--hostname ${cfg.hostname}"} \
          ${lib.optionalString cfg.useFQDN "--fqdn"} \
          /etc/labgrid/exporter/resources.yml'';
        Restart = "on-failure";
        SupplementaryGroups = cfg.extraGroups;
        DynamicUser = "yes";
        StateDirectory = "labgrid-exporter";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictRealtime = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
      };
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
    };
  };
}
