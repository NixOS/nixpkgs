{ config, lib, pkgs, ... }:

let
  cfg = config.services.ocsinventory-agent;

  settingsFormat = pkgs.formats.keyValue {
    mkKeyValue = lib.generators.mkKeyValueDefault { } "=";
  };

in
{
  meta = {
    doc = ./ocsinventory-agent.md;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };

  options = {
    services.ocsinventory-agent = {
      enable = lib.mkEnableOption (lib.mdDoc "OCS Inventory Agent");

      package = lib.mkPackageOption pkgs "ocsinventory-agent" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type.nestedTypes.elemType;

          options = {
            server = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              example = "https://ocsinventory.localhost:8080/ocsinventory";
              default = null;
              description = lib.mdDoc ''
                The URI of the OCS Inventory server where to send the inventory file.

                This option is ignored if {option}`services.ocsinventory-agent.settings.local` is set.
              '';
            };

            local = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              example = "/var/lib/ocsinventory-agent/reports";
              default = null;
              description = lib.mdDoc ''
                If specified, the OCS Inventory Agent will run in offline mode
                and the resulting inventory file will be stored in the specified path.
              '';
            };

            ca = lib.mkOption {
              type = lib.types.path;
              default = "/etc/ssl/certs/ca-certificates.crt";
              description = lib.mdDoc ''
                Path to CA certificates file in PEM format, for server
                SSL certificate validation.
              '';
            };

            tag = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = "01234567890123";
              description = lib.mdDoc "Tag for the generated inventory.";
            };

            debug = lib.mkEnableOption (lib.mdDoc "debug mode");
          };
        };
        default = { };
        example = {
          ca = "/etc/ssl/certs/ca-certificates.crt";
          debug = true;
          server = "https://ocsinventory.localhost:8080/ocsinventory";
          tag = "01234567890123";
        };
        description = lib.mdDoc ''
          Configuration for /etc/ocsinventory-agent/ocsinventory-agent.cfg.

          Refer to
          {manpage}`ocsinventory-agent(1)` for available options.
        '';
      };

      interval = lib.mkOption {
        type = lib.types.str;
        default = "daily";
        example = "06:00";
        description = lib.mdDoc ''
          How often we run the ocsinventory-agent service. Runs by default every daily.

          The format is described in
          {manpage}`systemd.time(7)`.
        '';
      };
    };
  };

  config =
    let
      configFile = settingsFormat.generate "ocsinventory-agent.cfg" cfg.settings;

    in lib.mkIf cfg.enable {
      # Path of the configuration file is hard-coded and cannot be changed
      # https://github.com/OCSInventory-NG/UnixAgent/blob/v2.10.0/lib/Ocsinventory/Agent/Config.pm#L78
      #
      environment.etc."ocsinventory-agent/ocsinventory-agent.cfg".source = configFile;

      systemd.services.ocsinventory-agent = {
        description = "OCS Inventory Agent service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        reloadTriggers = [ configFile ];

        serviceConfig = {
          ExecStart = lib.getExe cfg.package;
          ConfigurationDirectory = "ocsinventory-agent";
          StateDirectory = "ocsinventory-agent";
        };
      };

      systemd.timers.ocsinventory-agent = {
        description = "Launch OCS Inventory Agent regularly";
        wantedBy = [ "timers.target" ];

        timerConfig = {
          OnCalendar = cfg.interval;
          AccuracySec = "1h";
          RandomizedDelaySec = 240;
          Persistent = true;
          Unit = "ocsinventory-agent.service";
        };
      };
    };
}
