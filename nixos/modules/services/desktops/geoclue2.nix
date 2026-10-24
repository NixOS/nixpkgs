# GeoClue 2 daemon.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.geoclue2;
  ini = pkgs.formats.ini { listToValue = lib.concatStringsSep ";"; };
  appConfig' = lib.mapAttrs' (name: x: {
    name = x.desktopID or name;
    value =
      removeAttrs x [
        "desktopID"
        "isAllowed"
        "isSystem"
      ]
      // {
        allowed = if x.allowed != null then x.allowed else x.isAllowed or null;
        system = if x.system != null then x.system else x.isSystem or null;
      };
  }) cfg.appConfig;
in
{

  imports =
    let
      inherit (lib) mkRenamedOptionModule;
    in
    [
      (mkRenamedOptionModule
        [ "services" "geoclue2" "whitelistedAgents" ]
        [ "services" "geoclue2" "settings" "agent" "whitelist" ]
      )
      (mkRenamedOptionModule
        [ "services" "geoclue2" "enable3G" ]
        [ "services" "geoclue2" "settings" "3g" "enable" ]
      )
      (mkRenamedOptionModule
        [ "services" "geoclue2" "enableCDMA" ]
        [ "services" "geoclue2" "settings" "cdma" "enable" ]
      )
      (mkRenamedOptionModule
        [ "services" "geoclue2" "enableModemGPS" ]
        [ "services" "geoclue2" "settings" "modem-gps" "enable" ]
      )
      (mkRenamedOptionModule
        [ "services" "geoclue2" "enableNmea" ]
        [ "services" "geoclue2" "settings" "network-nmea" "enable" ]
      )
      (mkRenamedOptionModule
        [ "services" "geoclue2" "enableWifi" ]
        [ "services" "geoclue2" "settings" "wifi" "enable" ]
      )
      (mkRenamedOptionModule
        [ "services" "geoclue2" "geoProviderUrl" ]
        [ "services" "geoclue2" "settings" "wifi" "url" ]
      )
      (mkRenamedOptionModule
        [ "services" "geoclue2" "submitData" ]
        [ "services" "geoclue2" "settings" "wifi" "submit-data" ]
      )
      (mkRenamedOptionModule
        [ "services" "geoclue2" "submissionUrl" ]
        [ "services" "geoclue2" "settings" "wifi" "submission-url" ]
      )
      (mkRenamedOptionModule
        [ "services" "geoclue2" "submissionNick" ]
        [ "services" "geoclue2" "settings" "wifi" "submission-nick" ]
      )
      (mkRenamedOptionModule
        [ "services" "geoclue2" "enableStatic" ]
        [ "services" "geoclue2" "settings" "static-source" "enable" ]
      )
      (mkRenamedOptionModule
        [ "services" "geoclue2" "staticLatitude" ]
        [ "services" "geoclue2" "staticLocation" "latitude" ]
      )
      (mkRenamedOptionModule
        [ "services" "geoclue2" "staticLongitude" ]
        [ "services" "geoclue2" "staticLocation" "longitude" ]
      )
      (mkRenamedOptionModule
        [ "services" "geoclue2" "staticAltitude" ]
        [ "services" "geoclue2" "staticLocation" "altitude" ]
      )
      (mkRenamedOptionModule
        [ "services" "geoclue2" "staticAccuracy" ]
        [ "services" "geoclue2" "staticLocation" "accuracy" ]
      )
      (mkRenamedOptionModule
        [ "services" "geoclue2" "enableDemoAgent" ]
        [ "services" "geoclue2" "demoAgent" "enable" ]
      )
    ];

  ###### interface

  options = {

    services.geoclue2 = {

      enable = lib.mkEnableOption "GeoClue 2 daemon";

      settings = lib.mkOption {
        description = ''
          Configuration settings for GeoClue 2.  See {manpage}`geoclue(5)` for
          details.
        '';
        type = lib.types.submodule {
          freeformType = ini.type;
          options = {

            agent.whitelist = lib.mkOption {
              type = lib.types.nullOr (lib.types.listOf lib.types.str);
              default = [
                "gnome-shell"
                "io.elementary.desktop.agent-geoclue2"
              ]
              ++ lib.optionals cfg.demoAgent.enable [
                "geoclue-demo-agent"
              ];
              defaultText = lib.literalExpression ''
                [
                  "gnome-shell"
                  "io.elementary.desktop.agent-geoclue2"
                ]
                ++ lib.optionals config.geoclue2.demoAgent.enable [
                  "geoclue-demo-agent"
                ]
              '';
              description = ''
                Desktop IDs (without the .desktop extension) of whitelisted
                agents.
              '';
              apply = lib.unique;
            };
            ip = {
              enable = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = !cfg.settings.static-source.enable;
                defaultText = lib.literalExpression "!config.services.geoclue2.static-source.enable";
                description = ''
                  Enable the GeoIP source.
                '';
              };
              method = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = "ichnaea";
                description = ''
                  Method (backend) to use for IP location.  See
                  {manpage}`geoclue(5)` for available methods.
                '';
              };
            };
            network-nmea.enable = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = !cfg.settings.static-source.enable;
              defaultText = lib.literalExpression "!config.services.geoclue2.static-source.enable";
              description = ''
                Fetch location from NMEA sources on local network.  Sources are
                automatically discovered using avahi (domain `_nmea-0183._tcp`).
              '';
            };
            "3g".enable = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = !cfg.settings.static-source.enable;
              defaultText = lib.literalExpression "!config.services.geoclue2.static-source.enable";
              description = ''
                Enable 3G source.  The 3G source uses the wireless geolocation
                service URL defined for WiFi.
              '';
            };
            cdma.enable = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = !cfg.settings.static-source.enable;
              defaultText = lib.literalExpression "!config.services.geoclue2.static-source.enable";
              description = ''
                Enable CDMA source.
              '';
            };
            modem-gps.enable = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = !cfg.settings.static-source.enable;
              defaultText = lib.literalExpression "!config.services.geoclue2.static-source.enable";
              description = ''
                Enable Modem-GPS source.
              '';
            };
            wifi = {
              enable = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = !cfg.settings.static-source.enable;
                defaultText = lib.literalExpression "!config.services.geoclue2.static-source.enable";
                description = ''
                  Enable WiFi source.
                '';
              };
              submit-data = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = false;
                description = ''
                  Submit data to a wireless geolocation service.
                '';
              };
              submission-nick = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = "geoclue";
                description = ''
                  A nickname to submit network data with.  If set to an empty
                  string, omitted from the submission.  Otherwise, must be 2 to
                  32 characters long.
                '';
              };
            };
            compass.enable = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = !cfg.settings.static-source.enable;
              defaultText = lib.literalExpression "!config.services.geoclue2.static-source.enable";
              description = ''
                Enable Compass.
              '';
            };
            static-source.enable = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = cfg.staticLocation != null;
              defaultText = lib.literalExpression "config.geoclue2.staticLocation != null";
              description = ''
                Enable the static source.  If you make use of this source, you
                probably should disable other location sources so they won't
                override the configured static location.
              '';
            };

          };
        };
      };

      appConfig = lib.mkOption {
        description = ''
          Specify extra settings per application.  Appended to configuration
          file after settings.
        '';
        type = lib.types.attrsOf (
          lib.types.submodule {
            freeformType = ini.lib.types.section;
            options = {
              allowed = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = null;
                description = ''
                  Allowed access to location information.
                '';
              };
              system = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = null;
                description = ''
                  Is application a system component.
                '';
              };
              users = lib.mkOption {
                type = lib.types.nullOr (lib.types.listOf lib.types.str);
                default = [ ];
                description = ''
                  List of UIDs of all users for which this application is allowed
                  location info access.  Keep empty to allow for all users.
                '';
              };
            };
          }
        );
        defaultText = lib.literalExpression ''
          {
            "epiphany" = {
              allowed = true;
              system = false;
            };
            "firefox" = {
              allowed = true;
              system = false;
            };
          }
        '';
      };

      staticLocation = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.submodule {
            options = {
              latitude = lib.mkOption {
                type = lib.types.number;
                default = config.location.latitude;
                defaultText = lib.literalExpression "config.location.latitude";
                description = ''
                  Latitude to be used by `static-source`.
                '';
              };
              longitude = lib.mkOption {
                type = lib.types.number;
                default = config.location.longitude;
                defaultText = lib.literalExpression "config.location.longitude";
                description = ''
                  Longitude to be used by `static-source`.
                '';
              };
              altitude = lib.mkOption {
                type = lib.types.number;
                description = ''
                  Altitude in meters to be used by `static-source`.
                '';
              };
              accuracy = lib.mkOption {
                type = lib.types.number;
                description = ''
                  Accuracy radius in meters to be used by `static-source`.
                '';
              };
            };
          }
        );
        default = null;
        description = ''
          Static location to be used to be used by `static-source`.
        '';
      };

      demoAgent.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to use the GeoClue demo agent.  This should be overridden by
          desktop environments that provide their own agent.
        '';
      };

      package = lib.mkPackageOption pkgs "geoclue2" { } // {
        apply =
          pkg:
          pkg.override {
            # the demo agent isn't built by default, but we need it here
            withDemoAgent = cfg.demoAgent.enable;
          };
      };

    };

  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.intersectAttrs cfg.settings appConfig' == { };
        message = "Overlap between `services.geoclue2.settings' and `services.geoclue2.appConfig'. Cannot have an application with the same desktop ID as a settings section.";
      }
    ];

    warnings = lib.concatMap ({ cond, msg }: lib.optional cond msg) [
      {
        cond = lib.any (x: x ? desktopID) (lib.attrValues cfg.appConfig);
        msg = "Obsolete option `services.geoclue2.appConfig.<name>.desktopID' is used. It is now obtained from the <name> itself.";
      }
      {
        cond = lib.any (x: x ? isAllowed) (lib.attrValues cfg.appConfig);
        msg = "Obsolete option `services.geoclue2.appConfig.<name>.isAllowed' is used. It was renamed to `services.geoclue2.appConfig.<name>.allowed'.";
      }
      {
        cond = lib.any (x: x ? isSystem) (lib.attrValues cfg.appConfig);
        msg = "Obsolete option `services.geoclue2.appConfig.<name>.isSystem' is used. It was renamed to `services.geoclue2.appConfig.<name>.system'.";
      }
    ];

    services.geoclue2.appConfig = lib.mkDefault {
      "gnome-datetime-panel" = {
        allowed = true;
        system = true;
      };
      "gnome-color-panel" = {
        allowed = true;
        system = true;
      };
      "org.gnome.Shell" = {
        allowed = true;
        system = true;
      };
      "io.elementary.desktop.agent-geoclue2" = {
        allowed = true;
        system = true;
      };
      "epiphany" = {
        allowed = true;
        system = false;
      };
      "firefox" = {
        allowed = true;
        system = false;
      };
    };

    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

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
      wants = lib.optionals cfg.settings.wifi.enable [ "network-online.target" ];
      after = lib.optionals cfg.settings.wifi.enable [ "network-online.target" ];
      # restart geoclue service when the configuration changes
      restartTriggers = [
        config.environment.etc."geoclue/geoclue.conf".source
      ];
      serviceConfig.StateDirectory = "geoclue";
    };

    # this needs to run as a user service, since it's associated with the
    # user who is making the requests
    systemd.user.services = lib.mkIf cfg.demoAgent.enable {
      geoclue-agent = {
        description = "Geoclue agent";
        # this should really be `partOf = [ "geoclue.service" ]`, but
        # we can't be part of a system service, and the agent should
        # be okay with the main service coming and going
        wantedBy = [ "default.target" ];
        wants = lib.optionals cfg.settings.wifi.enable [ "network-online.target" ];
        after = lib.optionals cfg.settings.wifi.enable [ "network-online.target" ];
        unitConfig.ConditionUser = "!@system";
        serviceConfig = {
          Type = "exec";
          ExecStart = "${cfg.package}/libexec/geoclue-2.0/demos/agent";
          Restart = "on-failure";
          PrivateTmp = true;
        };
      };
    };

    environment.etc = {
      "geoclue/geoclue.conf".source = ini.generate "geoclue.conf" (cfg.settings // appConfig');

      "geolocation" = lib.mkIf (cfg.staticLocation != null) {
        mode = "0440";
        group = "geoclue";
        text = ''
          ${toString cfg.staticLocation.latitude}
          ${toString cfg.staticLocation.longitude}
          ${toString cfg.staticLocation.altitude}
          ${toString cfg.staticLocation.accuracy}
        '';
      };
    };
  };

  meta = {
    teams = [ lib.teams.pantheon ];
  };
}
