{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.chasemapper;
  format = pkgs.formats.ini { };
  chaseCfg = format.generate "horusmapper.cfg" cfg.settings;
in
{
  options = {
    services.chasemapper = {
      enable = lib.mkEnableOption "chasemapper";

      package = lib.mkPackageOption pkgs "chasemapper" { };

      settings = {
        profile_selection = {
          profile_count = lib.mkOption {
            default = 2;
            description = ''
              How many profiles have been defined
            '';
            type = lib.types.int;
          };
          default_profile = lib.mkOption {
            default = 1;
            description = ''
              Index of the default profile (indexing from 1)
            '';
            type = lib.types.int;
          };
        };

        profile_1 = {
          profile_name = lib.mkOption {
            default = "auto-rx";
            description = ''
              Profile name - will be shown in the web client.
            '';
            type = lib.types.str;
          };
          telemetry_source_type = lib.mkOption {
            default = "horus_udp";
            description = ''
              Telemetry source type
            '';
            type = lib.types.str;
          };
          telemetry_source_port = lib.mkOption {
            default = 55673;
            description = ''
              Telemetry source port (UDP)
            '';
            type = lib.types.int;
          };
          car_source_type = lib.mkOption {
            default = "serial";
            description = ''
              Car position source type
            '';
            type = lib.types.str;
          };
          car_source_port = lib.mkOption {
            default = 55672;
            description = ''
              Car position source port (UDP)
            '';
            type = lib.types.int;
          };
          online_tracker = lib.mkOption {
            default = "sondehub";
            description = ''
              Online Tracker System
            '';
            type = lib.types.str;
          };
        };

        profile_2 = {
          profile_name = lib.mkOption {
            default = "horus-gui";
            description = ''
              Profile name
            '';
            type = lib.types.str;
          };
          telemetry_source_type = lib.mkOption {
            default = "horus_udp";
            description = ''
              Telemetry source type
            '';
            type = lib.types.str;
          };
          telemetry_source_port = lib.mkOption {
            default = 55672;
            description = ''
              Telemetry source port (UDP)
            '';
            type = lib.types.int;
          };
          car_source_type = lib.mkOption {
            default = "serial";
            description = ''
              Car position source type
            '';
            type = lib.types.str;
          };
          car_source_port = lib.mkOption {
            default = 55672;
            description = ''
              Car position source port (UDP)
            '';
            type = lib.types.int;
          };
          online_tracker = lib.mkOption {
            default = "sondehubamateur";
            description = ''
              Online Tracker System
            '';
            type = lib.types.str;
          };
        };

        gpsd = {
          gpsd_host = lib.mkOption {
            default = "localhost";
            description = ''
              GPSD Host
            '';
            type = lib.types.str;
          };
          gpsd_port = lib.mkOption {
            default = 2947;
            description = ''
              GPSD Port
            '';
            type = lib.types.int;
          };
        };

        gps_serial = {
          gps_port = lib.mkOption {
            default = "/dev/ttyUSB0";
            description = ''
              GPS serial device
            '';
            type = lib.types.str;
          };
          gps_baud = lib.mkOption {
            default = 9600;
            description = ''
              GPS baud rate
            '';
            type = lib.types.int;
          };
        };

        map = {
          flask_host = lib.mkOption {
            default = "0.0.0.0";
            description = ''
              Host to host webserver on
            '';
            type = lib.types.str;
          };
          flask_port = lib.mkOption {
            default = 5001;
            description = ''
              Port for web server to listen on
            '';
            type = lib.types.int;
          };
          default_lat = lib.mkOption {
            default = -34.9;
            description = ''
              Default Map Latitude
            '';
            type = lib.types.float;
          };
          default_lon = lib.mkOption {
            default = 138.6;
            description = ''
              Default Map Longitude
            '';
            type = lib.types.float;
          };
          default_alt = lib.mkOption {
            default = 0.0;
            description = ''
              Default Map Altitude
            '';
            type = lib.types.float;
          };
          payload_max_age = lib.mkOption {
            default = 180;
            description = ''
              How long to keep payload data (minutes)
            '';
            type = lib.types.int;
          };
          thunderforest_api_key = lib.mkOption {
            default = "none";
            description = ''
              ThunderForest API Key
            '';
            type = lib.types.str;
          };
          stadia_api_key = lib.mkOption {
            default = "none";
            description = ''
              Stadia Maps API Key
            '';
            type = lib.types.str;
          };
        };

        predictor = {
          predictor_enabled = lib.mkOption {
            default = true;
            description = ''
              Enable Predictor
            '';
            type = lib.types.bool;
          };
          default_burst = lib.mkOption {
            default = 30000;
            description = ''
              Default burst
            '';
            type = lib.types.int;
          };
          default_descent_rate = lib.mkOption {
            default = 5.0;
            description = ''
              Default descent rate
            '';
            type = lib.types.float;
          };
          ascent_rate_averaging = lib.mkOption {
            default = 10;
            description = ''
              Ascent rate averaging
            '';
            type = lib.types.int;
          };
          offline_predictions = lib.mkOption {
            default = false;
            description = ''
              Use offline predictions
            '';
            type = lib.types.bool;
          };
          pred_binary = lib.mkOption {
            default = "./pred";
            description = ''
              Predictory Binary Location
            '';
            type = lib.types.str;
          };
          gfs_directory = lib.mkOption {
            default = "./gfs/";
            description = ''
              Directory containing GFS model data
            '';
            type = lib.types.str;
          };
          model_download = lib.mkOption {
            default = "none";
            description = ''
              Wind Model Download Command
            '';
            type = lib.types.str;
          };
        };

        offline_maps = {
          tile_server_enabled = lib.mkOption {
            default = false;
            description = ''
              Enable serving up maps from a directory of map tiles
            '';
            type = lib.types.bool;
          };
          tile_server_path = lib.mkOption {
            default = "/home/pi/Maps/";
            description = ''
              Path to map tiles
            '';
            type = lib.types.str;
          };
        };

        habitat = {
          habitat_upload_enabled = lib.mkOption {
            default = false;
            description = ''
              Enable uploading of chase-car position to SondeHub / SondeHub-Amateur
            '';
            type = lib.types.bool;
          };
          habitat_call = lib.mkOption {
            default = "N0CALL";
            description = ''
              Callsign to use when uploading
            '';
            type = lib.types.str;
          };
          habitat_update_rate = lib.mkOption {
            default = 30;
            description = ''
              Attempt to upload position to SondeHub every x seconds
            '';
            type = lib.types.int;
          };
        };

        range_rings = {
          range_rings_enabled = lib.mkOption {
            default = false;
            description = ''
              Enable Range Rings
            '';
            type = lib.types.bool;
          };
          range_ring_quantity = lib.mkOption {
            default = 5;
            description = ''
              Number of range rings to display
            '';
            type = lib.types.int;
          };
          range_ring_spacing = lib.mkOption {
            default = 1000;
            description = ''
              Spacing between rings, in metres
            '';
            type = lib.types.int;
          };
          range_ring_weight = lib.mkOption {
            default = 1.5;
            description = ''
              Weight of the ring, in pixels
            '';
            type = lib.types.float;
          };
          range_ring_color = lib.mkOption {
            default = "red";
            description = ''
              Color of the range rings
            '';
            type = lib.types.str;
          };
          range_ring_custom_color = lib.mkOption {
            default = "#FF0000";
            description = ''
              Custom range ring color, in hexadecimal #RRGGBB
            '';
            type = lib.types.str;
          };
        };

        speedo = {
          chase_car_speed = lib.mkOption {
            default = true;
            description = ''
              Display the chase car speed at the bottom left of the display
            '';
            type = lib.types.bool;
          };
        };

        bearings = {
          max_bearings = lib.mkOption {
            default = 300;
            description = ''
              Number of bearings to store
            '';
            type = lib.types.int;
          };
          max_bearing_age = lib.mkOption {
            default = 10;
            description = ''
              Maximum age of bearings, in _minutes_
            '';
            type = lib.types.int;
          };
          car_speed_gate = lib.mkOption {
            default = 10;
            description = ''
              Car heading speed gate
            '';
            type = lib.types.int;
          };
          turn_rate_threshold = lib.mkOption {
            default = 4.0;
            description = ''
              Turn rate threshold
            '';
            type = lib.types.float;
          };
          bearing_length = lib.mkOption {
            default = 10;
            description = ''
              Bearing length in km
            '';
            type = lib.types.int;
          };
          bearing_weight = lib.mkOption {
            default = 1.0;
            description = ''
              Weight of the bearing lines, in pixels
            '';
            type = lib.types.float;
          };
          bearing_color = lib.mkOption {
            default = "red";
            description = ''
              Color of the bearings
            '';
            type = lib.types.str;
          };
          bearing_custom_color = lib.mkOption {
            default = "#FF0000";
            description = ''
              Custom bearing color, in hexadecimal #RRGGBB
            '';
            type = lib.types.str;
          };
        };

        units = {
          unitselection = lib.mkOption {
            default = "metric";
            description = ''
              unitselection allows choice of metric
            '';
            type = lib.types.str;
          };
          switch_miles_feet = lib.mkOption {
            default = 400;
            description = ''
              This is the threshold for switching from miles to feet, set in metres.
            '';
            type = lib.types.int;
          };
        };

        history = {
          reload_last_position = lib.mkOption {
            default = false;
            description = ''
              Enable load of last position from log files
            '';
            type = lib.types.bool;
          };
        };
      };

      openPorts = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open firewall ports for chasemapper";
      };

    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.chasemapper = {
      serviceConfig = {
        Type = "simple";
        Restart = "always";

        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package} --nolog -c ${chaseCfg}";
      };

      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      description = "Chasemapper";
      wantedBy = [ "multi-user.target" ];
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openPorts [
      cfg.settings.map.flask_port
    ];
  };
}
