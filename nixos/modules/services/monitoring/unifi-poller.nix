{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.unifi-poller;

  configFile = pkgs.writeText "unifi-poller.json" (generators.toJSON {} {
    inherit (cfg) poller influxdb loki prometheus unifi;
  });

in {
  options.services.unifi-poller = {
    enable = mkEnableOption "unifi-poller";

    poller = {
      debug = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Turns on line numbers, microsecond logging, and a per-device log.
          This may be noisy if you have a lot of devices. It adds one line per device.
        '';
      };
      quiet = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Turns off per-interval logs. Only startup and error logs will be emitted.
        '';
      };
      plugins = mkOption {
        type = with types; listOf str;
        default = [];
        description = ''
          Load additional plugins.
        '';
      };
    };

    prometheus = {
      disable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to disable the prometheus ouput plugin.
        '';
      };
      http_listen = mkOption {
        type = types.str;
        default = "[::]:9130";
        description = ''
          Bind the prometheus exporter to this IP or hostname.
        '';
      };
      report_errors = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to report errors.
        '';
      };
    };

    influxdb = {
      disable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to disable the influxdb ouput plugin.
        '';
      };
      url = mkOption {
        type = types.str;
        default = "http://127.0.0.1:8086";
        description = ''
          URL of the influxdb host.
        '';
      };
      user = mkOption {
        type = types.str;
        default = "unifipoller";
        description = ''
          Username for the influxdb.
        '';
      };
      pass = mkOption {
        type = types.path;
        default = pkgs.writeText "unifi-poller-influxdb-default.password" "unifipoller";
        defaultText = literalExpression "unifi-poller-influxdb-default.password";
        description = ''
          Path of a file containing the password for influxdb.
          This file needs to be readable by the unifi-poller user.
        '';
        apply = v: "file://${v}";
      };
      db = mkOption {
        type = types.str;
        default = "unifi";
        description = ''
          Database name. Database should exist.
        '';
      };
      verify_ssl = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Verify the influxdb's certificate.
        '';
      };
      interval = mkOption {
        type = types.str;
        default = "30s";
        description = ''
          Setting this lower than the Unifi controller's refresh
          interval may lead to zeroes in your database.
        '';
      };
    };

    loki = {
      url = mkOption {
        type = types.str;
        default = "";
        description = ''
          URL of the Loki host.
        '';
      };
      user = mkOption {
        type = types.str;
        default = "";
        description = ''
          Username for Loki.
        '';
      };
      pass = mkOption {
        type = types.path;
        default = pkgs.writeText "unifi-poller-loki-default.password" "";
        defaultText = "unifi-poller-influxdb-default.password";
        description = ''
          Path of a file containing the password for Loki.
          This file needs to be readable by the unifi-poller user.
        '';
        apply = v: "file://${v}";
      };
      verify_ssl = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Verify Loki's certificate.
        '';
      };
      tenant_id = mkOption {
        type = types.str;
        default = "";
        description = ''
          Tenant ID to use in Loki.
        '';
      };
      interval = mkOption {
        type = types.str;
        default = "2m";
        description = ''
          How often the events are polled and pushed to Loki.
        '';
      };
      timeout = mkOption {
        type = types.str;
        default = "10s";
        description = ''
          Should be increased in case of timeout errors.
        '';
      };
    };

    unifi = let
      controllerOptions = {
        user = mkOption {
          type = types.str;
          default = "unifi";
          description = ''
            Unifi service user name.
          '';
        };
        pass = mkOption {
          type = types.path;
          default = pkgs.writeText "unifi-poller-unifi-default.password" "unifi";
          defaultText = literalExpression "unifi-poller-unifi-default.password";
          description = ''
            Path of a file containing the password for the unifi service user.
            This file needs to be readable by the unifi-poller user.
          '';
          apply = v: "file://${v}";
        };
        url = mkOption {
          type = types.str;
          default = "https://unifi:8443";
          description = ''
            URL of the Unifi controller.
          '';
        };
        sites = mkOption {
          type = with types; either (enum [ "default" "all" ]) (listOf str);
          default = "all";
          description = ''
            List of site names for which statistics should be exported.
            Or the string "default" for the default site or the string "all" for all sites.
          '';
          apply = toList;
        };
        save_ids = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Collect and save data from the intrusion detection system to influxdb and Loki.
          '';
        };
        save_events = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Collect and save data from UniFi events to influxdb and Loki.
          '';
        };
        save_alarms = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Collect and save data from UniFi alarms to influxdb and Loki.
          '';
        };
        save_anomalies = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Collect and save data from UniFi anomalies to influxdb and Loki.
          '';
        };
        save_dpi = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Collect and save data from deep packet inspection.
            Adds around 150 data points and impacts performance.
          '';
        };
        save_sites = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Collect and save site data.
          '';
        };
        hash_pii = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Hash, with md5, client names and MAC addresses. This attempts
            to protect personally identifiable information.
          '';
        };
        verify_ssl = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Verify the Unifi controller's certificate.
          '';
        };
      };

    in {
      dynamic = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Let prometheus select which controller to poll when scraping.
          Use with default credentials. See unifi-poller wiki for more.
        '';
      };

      defaults = controllerOptions;

      controllers = mkOption {
        type = with types; listOf (submodule { options = controllerOptions; });
        default = [];
        description = ''
          List of Unifi controllers to poll. Use defaults if empty.
        '';
        apply = map (flip removeAttrs [ "_module" ]);
      };
    };
  };

  config = mkIf cfg.enable {
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
        ExecStart = "${pkgs.unifi-poller}/bin/unifi-poller --config ${configFile}";
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
