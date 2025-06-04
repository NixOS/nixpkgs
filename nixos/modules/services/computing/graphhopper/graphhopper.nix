{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.graphhopper;
in
{
  options.services.graphhopper = {
    enable = lib.mkEnableOption "Fast and memory-efficient routing engine for OpenStreetMap";
    package = lib.mkPackageOption pkgs "graphhopper" { };

    graphLocation = lib.mkOption {
      type = lib.types.str;
      default = "/var/cache/graphhopper";
      example = "/var/cache/graphhopper";
      description = "The location to place the graph cache in (must be owned by the graphhopper systemd DynamicUser) - equivalent to `graph.location` field in graphhopper yml config.";
    };

    datareaderFile = lib.mkOption {
      type = lib.types.pathInStore;
      example = ''
        pkgs.fetchurl {
                url = "https://download.geofabrik.de/antarctica-140101.osm.pbf";
                hash = "sha256-6wxFxsCnKYotddUCsv3ioe8k+EhDViMG3jbtDMwbXsw=";
              }'';
      description = "The OSM data to use with graphhopper - equivalent to `datareader.file` field in graphhopper yml config.";
    };

    gtfsFile = lib.mkOption {
      type = lib.types.pathInStore;
      example = ''
        pkgs.fetchurl {
                url = "https://github.com/google/transit/blob/master/gtfs/spec/en/examples/sample-feed-1.zip?raw=true";
                hash = "sha256-RkBPkbj4Ur8QN/eQGrwhXZHRu+KkNixbAqP5ztU8jWU=";
              }'';
      description = "The GTFS data to use with graphhopper - equivalent to `gtfs.file` field in graphhopper yml config.";
    };

    server = lib.mkOption {
      type = lib.types.attrs;
      example = {
        application_connectors = [
          {
            type = "http";
            port = 8989;
            bind_host = "localhost";
          }
        ];
        admin_connectors = [
          {
            type = "http";
            port = 8990;
            bind_host = "localhost";
          }
        ];
      };
      default = {
        application_connectors = [
          {
            type = "http";
            port = 8989;
            bind_host = "localhost";
          }
        ];
        admin_connectors = [
          {
            type = "http";
            port = 8990;
            bind_host = "localhost";
          }
        ];
      };
      description = "Graphhopper dropwizard server configuration settings";
    };

    ignoredHighways = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      example = [
        "cycleway"
        "motorway"
        "trunk"
      ];
      default = [
        "motorway"
        "trunk"
      ];
      description = "Ignored OpenStreetMap highways - maps to `import.osm.ignored_highways`.";
    };

    profiles = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      example = [
        {
          name = "foot";
          custom_model_files = [ "foot.json" ];
        }
        {
          name = "pt";
          custom_model_files = [ "bus.json" ];
        }
      ];
      default = [
        {
          name = "foot";
          custom_model_files = [ "foot.json" ];
        }
      ];
      description = "Graphhopper profiles to use";
    };

    encodedValues = lib.mkOption {
      type = lib.types.str;
      example = "foot_access, foot_average_speed, foot_priority, hike_rating, mtb_rating, country, road_class, road_access, max_weight, max_width, max_height, bus_access, car_average_speed";
      default = "foot_access, foot_average_speed, foot_priority, hike_rating, mtb_rating, country, road_class";
      description = "Encoded values to use for the graph";
    };

    extraConfig = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      example = {
        graphhopper."graph.elevation.dataaccess" = "RAM_STORE";
      };
      description = "Extra configuration to be converted to yml and passed to graphhopper. See https://github.com/graphhopper/graphhopper/blob/master/config-example.yml";
    };

    extraYmlConfig = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = ''
        graphhopper:
          graph.elevation.dataaccess: RAM_STORE
      '';
      description = "An extra inline yml string to be appended to the end of `extraConfig`";
    };
  };

  config = lib.mkIf cfg.enable (
    let
      with-nix-options = lib.recursiveUpdate cfg.extraConfig {
        graphhopper = {
          "graph.location" = cfg.graphLocation;
          "datareader.file" = cfg.datareaderFile;
          "gtfs.file" = cfg.gtfsFile;
          "import.osm.ignored_highways" = cfg.ignoredHighways;
          "graph.encoded_values" = cfg.encodedValues;
          profiles = cfg.profiles;
        };
        server = cfg.server;
      };

      graphhopper-config = pkgs.callPackage (
        { runCommand, remarshal_0_17 }:
        runCommand "graphhopper-config.yml"
          {
            nativeBuildInputs = [ remarshal_0_17 ];
            value = builtins.toJSON with-nix-options;
            passAsFile = [ "value" ];
            preferLocalBuild = true;
          }
          ''
            json2yaml "$valuePath" "$out"

            echo "${cfg.extraYmlConfig}" >> "$out"
          ''
      ) { };
    in
    {
      environment.systemPackages = [ cfg.package ];

      systemd.targets.graphhopper = {
        description = "GraphHopper Service Ready";
        wantedBy = [ "multi-user.target" ];
      };

      systemd.services.graphhopper = {
        enable = true;
        description = "GraphHopper Routing Engine";
        after = [ "network.target" ];
        wantedBy = [ "graphhopper.target" ];

        serviceConfig = {
          ExecStart = ''
            ${cfg.package}/bin/graphhopper server ${graphhopper-config}
          '';

          DynamicUser = true;
          CacheDirectory = "graphhopper";
          WorkingDirectory = "/var/cache/graphhopper";

          Restart = "always";

          RestrictRealtime = true;
          RestrictNamespaces = true;
          LockPersonality = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          ProtectClock = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          CapabilityBoundingSet = "";
          ProtectProc = "invisible";
        };
      };
    }
  );

  meta = {
    maintainers = with lib.maintainers; [
      baileylu
    ];
    doc = ./graphhopper.md;
  };
}
