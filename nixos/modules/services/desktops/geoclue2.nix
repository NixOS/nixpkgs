# GeoClue 2 daemon.

{ config, lib, pkgs, ... }:

with lib;

let
  # the demo agent isn't built by default, but we need it here
  package = pkgs.geoclue2.override { withDemoAgent = config.services.geoclue2.enableDemoAgent; };

  cfg = config.services.geoclue2;

  semiColon = concatStringsSep ";";

  appConfigModule = types.submodule ({ name, ... }: {
    options = {
      desktopID = mkOption {
        type = types.str;
        description = "Desktop ID of the application.";
      };

      isAllowed = mkOption {
        type = types.bool;
        default = null;
        description = ''
          Whether the application will be allowed access to location information.
        '';
      };

      isSystem = mkOption {
        type = types.bool;
        default = null;
        description = ''
          Whether the application is a system component or not.
        '';
      };

      users = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          List of UIDs of all users for which this application is allowed location
          info access, Defaults to an empty string to allow it for all users.
        '';
      };
    };

    config.desktopID = mkDefault name;
  });

  appConfigStr = cf: concatStringsSep "\n" (
    ["[${cf.desktopID}]"]
     ++ optional (cf.isAllowed  != null)  "allowed=${boolToString cf.isAllowed}"
     ++ optional (cf.isSystem   != null)  "system=${boolToString cf.isSystem}"
     ++ ["users=${semiColon cf.users}"]
     ++ [""]
  );

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
        type = types.loaOf appConfigModule;
        default = {};
        example = literalExample ''
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

    # this needs to run as a user service, since it's associated with the
    # user who is making the requests
    systemd.user.services = mkIf cfg.enableDemoAgent {
      "geoclue-agent" = {
        description = "Geoclue agent";
        script = "${package}/libexec/geoclue-2.0/demos/agent";
        # this should really be `partOf = [ "geoclue.service" ]`, but
        # we can't be part of a system service, and the agent should
        # be okay with the main service coming and going
        wantedBy = [ "default.target" ];
      };
    };

    services.geoclue2.appConfig."epiphany" = {
      isAllowed = true;
      isSystem = false;
    };

    services.geoclue2.appConfig."firefox" = {
      isAllowed = true;
      isSystem = false;
    };

    environment.etc."geoclue/geoclue.conf".text = ''
    # Configuration file for Geoclue

    # Agent configuration options
    [agent]

    whitelist=${let whitelist = optional cfg.enableDemoAgent "geoclue-demo-agent" ++ singleton "gnome-shell;io.elementary.desktop.agent-geoclue2"; in semiColon whitelist}

    # Network NMEA source configuration options
    [network-nmea]

    enable=${boolToString cfg.enableNmea}

    # 3G source configuration options
    [3g]

    enable=${boolToString cfg.enable3G}

    # CDMA source configuration options
    [cdma]

    enable=${boolToString cfg.enableCDMA}

    # Modem GPS source configuration options
    [modem-gps]

    enable=${boolToString cfg.enableModemGPS}

    # WiFi source configuration options
    [wifi]

    enable=${boolToString cfg.enableWifi}

    url=${cfg.geoProviderUrl}

    submit-data=${boolToString cfg.submitData}

    submission-url=${cfg.submissionUrl}

    submission-nick=${cfg.submissionNick}

    ${concatMapStringsSep "\n" appConfigStr (
        builtins.attrValues cfg.appConfig)}
    '';
  };

}
