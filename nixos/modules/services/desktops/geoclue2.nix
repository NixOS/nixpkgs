# GeoClue 2 daemon.

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  # the demo agent isn't built by default, but we need it here
  package = pkgs.geoclue2.override { withDemoAgent = config.services.geoclue2.enableDemoAgent; };

  cfg = config.services.geoclue2;

  defaultWhitelist = [
    "gnome-shell"
    "io.elementary.desktop.agent-geoclue2"
  ];

  appConfigModule = types.submodule (
    { name, ... }:
    {
      options = {
        desktopID = mkOption {
          type = types.str;
          description = "Desktop ID of the application.";
        };

        isAllowed = mkOption {
          type = types.bool;
          description = ''
            Whether the application will be allowed access to location information.
          '';
        };

        isSystem = mkOption {
          type = types.bool;
          description = ''
            Whether the application is a system component or not.
          '';
        };

        users = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            List of UIDs of all users for which this application is allowed location
            info access, Defaults to an empty string to allow it for all users.
          '';
        };
      };

      config.desktopID = mkDefault name;
    }
  );

  appConfigToINICompatible =
    _:
    {
      desktopID,
      isAllowed,
      isSystem,
      users,
      ...
    }:
    {
      name = desktopID;
      value = {
        allowed = isAllowed;
        system = isSystem;
        users = concatStringsSep ";" users;
      };
    };

in
{

  ###### interface

  options = {

    services.geoclue2 = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable GeoClue 2 daemon, a DBus service
          that provides location information for accessing.
        '';
      };

      enableDemoAgent = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to use the GeoClue demo agent. This should be
          overridden by desktop environments that provide their own
          agent.
        '';
      };

      enableNmea = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to fetch location from NMEA sources on local network.
        '';
      };

      enable3G = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable 3G source.
        '';
      };

      enableCDMA = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable CDMA source.
        '';
      };

      enableModemGPS = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable Modem-GPS source.
        '';
      };

      enableWifi = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable WiFi source.
        '';
      };

      geoProviderUrl = mkOption {
        type = types.str;
        default = "https://location.services.mozilla.com/v1/geolocate?key=geoclue";
        example = "https://www.googleapis.com/geolocation/v1/geolocate?key=YOUR_KEY";
        description = ''
          The url to the wifi GeoLocation Service.
        '';
      };

      submitData = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to submit data to a GeoLocation Service.
        '';
      };

      submissionUrl = mkOption {
        type = types.str;
        default = "https://location.services.mozilla.com/v1/submit?key=geoclue";
        description = ''
          The url to submit data to a GeoLocation Service.
        '';
      };

      submissionNick = mkOption {
        type = types.str;
        default = "geoclue";
        description = ''
          A nickname to submit network data with.
          Must be 2-32 characters long.
        '';
      };

      appConfig = mkOption {
        type = types.attrsOf appConfigModule;
        default = { };
        example = literalExpression ''
          "com.github.app" = {
            isAllowed = true;
            isSystem = true;
            users = [ "300" ];
          };
        '';
        description = ''
          Specify extra settings per application.
        '';
      };

    };

  };

  ###### implementation
  config = mkIf cfg.enable {

    environment.systemPackages = [ package ];

    services.dbus.packages = [ package ];

    systemd.packages = [ package ];

    # we cannot use DynamicUser as we need the the geoclue user to exist for the
    # dbus policy to work
    users = {
      users.geoclue = {
        isSystemUser = true;
        home = "/var/lib/geoclue";
        group = "geoclue";
        description = "Geoinformation service";
      };

      groups.geoclue = { };
    };

    systemd.services.geoclue = {
      wants = lib.optionals cfg.enableWifi [ "network-online.target" ];
      after = lib.optionals cfg.enableWifi [ "network-online.target" ];
      # restart geoclue service when the configuration changes
      restartTriggers = [
        config.environment.etc."geoclue/geoclue.conf".source
      ];
      serviceConfig.StateDirectory = "geoclue";
    };

    # this needs to run as a user service, since it's associated with the
    # user who is making the requests
    systemd.user.services = mkIf cfg.enableDemoAgent {
      geoclue-agent = {
        description = "Geoclue agent";
        # this should really be `partOf = [ "geoclue.service" ]`, but
        # we can't be part of a system service, and the agent should
        # be okay with the main service coming and going
        wantedBy = [ "default.target" ];
        wants = lib.optionals cfg.enableWifi [ "network-online.target" ];
        after = lib.optionals cfg.enableWifi [ "network-online.target" ];
        unitConfig.ConditionUser = "!@system";
        serviceConfig = {
          Type = "exec";
          ExecStart = "${package}/libexec/geoclue-2.0/demos/agent";
          Restart = "on-failure";
          PrivateTmp = true;
        };
      };
    };

    services.geoclue2.appConfig.epiphany = {
      isAllowed = true;
      isSystem = false;
    };

    services.geoclue2.appConfig.firefox = {
      isAllowed = true;
      isSystem = false;
    };

    environment.etc."geoclue/geoclue.conf".text = generators.toINI { } (
      {
        agent = {
          whitelist = concatStringsSep ";" (
            optional cfg.enableDemoAgent "geoclue-demo-agent" ++ defaultWhitelist
          );
        };
        network-nmea = {
          enable = cfg.enableNmea;
        };
        "3g" = {
          enable = cfg.enable3G;
        };
        cdma = {
          enable = cfg.enableCDMA;
        };
        modem-gps = {
          enable = cfg.enableModemGPS;
        };
        wifi = {
          enable = cfg.enableWifi;
          url = cfg.geoProviderUrl;
          submit-data = boolToString cfg.submitData;
          submission-url = cfg.submissionUrl;
          submission-nick = cfg.submissionNick;
        };
      }
      // mapAttrs' appConfigToINICompatible cfg.appConfig
    );
  };

  meta = with lib; {
    maintainers = with maintainers; [ ] ++ teams.pantheon.members;
  };
}
