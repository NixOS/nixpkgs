{ config, lib, pkgs, ... }:
let
  cfg = config.services.unpoller;

  configFile = pkgs.writeText "unpoller.json" (lib.generators.toJSON {} {
    inherit (cfg) poller influxdb loki prometheus unifi;
  });

in {
  imports = [
    (lib.mkRenamedOptionModule [ "services" "unifi-poller" ] [ "services" "unpoller" ])
  ];

  options.services.unpoller = {
    enable = lib.mkEnableOption "unpoller";

    poller = {
      debug = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Turns on line numbers, microsecond logging, and a per-device log.
          This may be noisy if you have a lot of devices. It adds one line per device.
        '';
      };
      quiet = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Turns off per-interval logs. Only startup and error logs will be emitted.
        '';
      };
      plugins = lib.mkOption {
        type = with lib.types; listOf str;
        default = [];
        description = ''
          Load additional plugins.
        '';
      };
    };

    prometheus = {
      disable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to disable the prometheus output plugin.
        '';
      };
      http_listen = lib.mkOption {
        type = lib.types.str;
        default = "[::]:9130";
        description = ''
          Bind the prometheus exporter to this IP or hostname.
        '';
      };
      report_errors = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to report errors.
        '';
      };
    };

    influxdb = {
      disable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to disable the influxdb output plugin.
        '';
      };
      url = lib.mkOption {
        type = lib.types.str;
        default = "http://127.0.0.1:8086";
        description = ''
          URL of the influxdb host.
        '';
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "unifipoller";
        description = ''
          Username for the influxdb.
        '';
      };
      pass = lib.mkOption {
        type = lib.types.path;
        default = pkgs.writeText "unpoller-influxdb-default.password" "unifipoller";
        defaultText = lib.literalExpression "unpoller-influxdb-default.password";
        description = ''
          Path of a file containing the password for influxdb.
          This file needs to be readable by the unifi-poller user.
        '';
        apply = v: "file://${v}";
      };
      db = lib.mkOption {
        type = lib.types.str;
        default = "unifi";
        description = ''
          Database name. Database should exist.
        '';
      };
      verify_ssl = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Verify the influxdb's certificate.
        '';
      };
      interval = lib.mkOption {
        type = lib.types.str;
        default = "30s";
        description = ''
          Setting this lower than the Unifi controller's refresh
          interval may lead to zeroes in your database.
        '';
      };
    };

    loki = {
      url = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          URL of the Loki host.
        '';
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Username for Loki.
        '';
      };
      pass = lib.mkOption {
        type = lib.types.path;
        default = pkgs.writeText "unpoller-loki-default.password" "";
        defaultText = "unpoller-influxdb-default.password";
        description = ''
          Path of a file containing the password for Loki.
          This file needs to be readable by the unifi-poller user.
        '';
        apply = v: "file://${v}";
      };
      verify_ssl = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Verify Loki's certificate.
        '';
      };
      tenant_id = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Tenant ID to use in Loki.
        '';
      };
      interval = lib.mkOption {
        type = lib.types.str;
        default = "2m";
        description = ''
          How often the events are polled and pushed to Loki.
        '';
      };
      timeout = lib.mkOption {
        type = lib.types.str;
        default = "10s";
        description = ''
          Should be increased in case of timeout errors.
        '';
      };
    };

    unifi = let
      controllerOptions = {
        user = lib.mkOption {
          type = lib.types.str;
          default = "unifi";
          description = ''
            Unifi service user name.
          '';
        };
        pass = lib.mkOption {
          type = lib.types.path;
          default = pkgs.writeText "unpoller-unifi-default.password" "unifi";
          defaultText = lib.literalExpression "unpoller-unifi-default.password";
          description = ''
            Path of a file containing the password for the unifi service user.
            This file needs to be readable by the unifi-poller user.
          '';
          apply = v: "file://${v}";
        };
        url = lib.mkOption {
          type = lib.types.str;
          default = "https://unifi:8443";
          description = ''
            URL of the Unifi controller.
          '';
        };
        sites = lib.mkOption {
          type = with lib.types; either (enum [ "default" "all" ]) (listOf str);
          default = "all";
          description = ''
            List of site names for which statistics should be exported.
            Or the string "default" for the default site or the string "all" for all sites.
          '';
          apply = lib.toList;
        };
        save_ids = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Collect and save data from the intrusion detection system to influxdb and Loki.
          '';
        };
        save_events = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Collect and save data from UniFi events to influxdb and Loki.
          '';
        };
        save_alarms = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Collect and save data from UniFi alarms to influxdb and Loki.
          '';
        };
        save_anomalies = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Collect and save data from UniFi anomalies to influxdb and Loki.
          '';
        };
        save_dpi = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Collect and save data from deep packet inspection.
            Adds around 150 data points and impacts performance.
          '';
        };
        save_sites = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Collect and save site data.
          '';
        };
        hash_pii = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Hash, with md5, client names and MAC addresses. This attempts
            to protect personally identifiable information.
          '';
        };
        verify_ssl = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Verify the Unifi controller's certificate.
          '';
        };
      };

    in {
      dynamic = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Let prometheus select which controller to poll when scraping.
          Use with default credentials. See unifi-poller wiki for more.
        '';
      };

      defaults = controllerOptions;

      controllers = lib.mkOption {
        type = with lib.types; listOf (submodule { options = controllerOptions; });
        default = [];
        description = ''
          List of Unifi controllers to poll. Use defaults if empty.
        '';
        apply = map (lib.flip removeAttrs [ "_module" ]);
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.unifi-poller = { };
    users.users.unifi-poller = {
      description = "unifi-poller Service User";
      group = "unifi-poller";
      isSystemUser = true;
    };

    systemd.services.unifi-poller = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.unpoller}/bin/unpoller --config ${configFile}";
        Restart = "always";
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "full";
        DevicePolicy = "closed";
        NoNewPrivileges = true;
        User = "unifi-poller";
        WorkingDirectory = "/tmp";
      };
    };
  };
}
