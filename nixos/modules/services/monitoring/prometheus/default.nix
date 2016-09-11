{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus;
  promUser = "prometheus";
  promGroup = "prometheus";

  # Get a submodule without any embedded metadata:
  _filter = x: filterAttrs (k: v: k != "_module") x;

  # Pretty-print JSON to a file
  writePrettyJSON = name: x:
    pkgs.runCommand name { } ''
      echo '${builtins.toJSON x}' | ${pkgs.jq}/bin/jq . > $out
    '';

  # This becomes the main config file
  promConfig = {
    global = cfg.globalConfig;
    rule_files = cfg.ruleFiles ++ [
      (pkgs.writeText "prometheus.rules" (concatStringsSep "\n" cfg.rules))
    ];
    scrape_configs = cfg.scrapeConfigs;
  };

  cmdlineArgs = cfg.extraFlags ++ [
    "-storage.local.path=${cfg.dataDir}/metrics"
    "-config.file=${writePrettyJSON "prometheus.yml" promConfig}"
    "-web.listen-address=${cfg.listenAddress}"
  ];

  promTypes.globalConfig = types.submodule {
    options = {
      scrape_interval = mkOption {
        type = types.str;
        default = "1m";
        description = ''
          How frequently to scrape targets by default.
        '';
      };

      scrape_timeout = mkOption {
        type = types.str;
        default = "10s";
        description = ''
          How long until a scrape request times out.
        '';
      };

      evaluation_interval = mkOption {
        type = types.str;
        default = "1m";
        description = ''
          How frequently to evaluate rules by default.
        '';
      };

      labels = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = ''
          The labels to add to any timeseries that this Prometheus instance
          scrapes.
        '';
      };
    };
  };

  promTypes.scrape_config = types.submodule {
    options = {
      job_name = mkOption {
        type = types.str;
        description = ''
          The job name assigned to scraped metrics by default.
        '';
      };
      scrape_interval = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          How frequently to scrape targets from this job. Defaults to the
          globally configured default.
        '';
      };
      scrape_timeout = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Per-target timeout when scraping this job. Defaults to the
          globally configured default.
        '';
      };
      metrics_path = mkOption {
        type = types.str;
        default = "/metrics";
        description = ''
          The HTTP resource path on which to fetch metrics from targets.
        '';
      };
      scheme = mkOption {
        type = types.enum ["http" "https"];
        default = "http";
        description = ''
          The URL scheme with which to fetch metrics from targets.
        '';
      };
      basic_auth = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            username = mkOption {
              type = types.str;
              description = ''
                HTTP username
              '';
            };
            password = mkOption {
              type = types.str;
              description = ''
                HTTP password
              '';
            };
          };
        });
        default = null;
        description = ''
          Optional http login credentials for metrics scraping.
        '';
      };
      dns_sd_configs = mkOption {
        type = types.listOf promTypes.dns_sd_config;
        default = [];
        apply = x: map _filter x;
        description = ''
          List of DNS service discovery configurations.
        '';
      };
      consul_sd_configs = mkOption {
        type = types.listOf promTypes.consul_sd_config;
        default = [];
        apply = x: map _filter x;
        description = ''
          List of Consul service discovery configurations.
        '';
      };
      file_sd_configs = mkOption {
        type = types.listOf promTypes.file_sd_config;
        default = [];
        apply = x: map _filter x;
        description = ''
          List of file service discovery configurations.
        '';
      };
      static_configs = mkOption {
        type = types.listOf promTypes.static_config;
        default = [];
        apply = x: map _filter x;
        description = ''
          List of labeled target groups for this job.
        '';
      };
      relabel_configs = mkOption {
        type = types.listOf promTypes.relabel_config;
        default = [];
        apply = x: map _filter x;
        description = ''
          List of relabel configurations.
        '';
      };
    };
  };

  promTypes.static_config = types.submodule {
    options = {
      targets = mkOption {
        type = types.listOf types.str;
        description = ''
          The targets specified by the target group.
        '';
      };
      labels = mkOption {
        type = types.attrsOf types.str;
        description = ''
          Labels assigned to all metrics scraped from the targets.
        '';
      };
    };
  };

  promTypes.dns_sd_config = types.submodule {
    options = {
      names = mkOption {
        type = types.listOf types.str;
        description = ''
          A list of DNS SRV record names to be queried.
        '';
      };
      refresh_interval = mkOption {
        type = types.str;
        default = "30s";
        description = ''
          The time after which the provided names are refreshed.
        '';
      };
    };
  };

  promTypes.consul_sd_config = types.submodule {
    options = {
      server = mkOption {
        type = types.str;
        description = "Consul server to query.";
      };
      token = mkOption {
        type = types.nullOr types.str;
        description = "Consul token";
      };
      datacenter = mkOption {
        type = types.nullOr types.str;
        description = "Consul datacenter";
      };
      scheme = mkOption {
        type = types.nullOr types.str;
        description = "Consul scheme";
      };
      username = mkOption {
        type = types.nullOr types.str;
        description = "Consul username";
      };
      password = mkOption {
        type = types.nullOr types.str;
        description = "Consul password";
      };

      services = mkOption {
        type = types.listOf types.str;
        description = ''
          A list of services for which targets are retrieved.
        '';
      };
      tag_separator = mkOption {
        type = types.str;
        default = ",";
        description = ''
          The string by which Consul tags are joined into the tag label.
        '';
      };
    };
  };

  promTypes.file_sd_config = types.submodule {
    options = {
      files = mkOption {
        type = types.listOf types.str;
        description = ''
          Patterns for files from which target groups are extracted. Refer
          to the Prometheus documentation for permitted filename patterns
          and formats.

        '';
      };
      refresh_interval = mkOption {
        type = types.str;
        default = "30s";
        description = ''
          Refresh interval to re-read the files.
        '';
      };
    };
  };

  promTypes.relabel_config = types.submodule {
    options = {
      source_labels = mkOption {
        type = types.listOf types.str;
        description = ''
          The source labels select values from existing labels. Their content
          is concatenated using the configured separator and matched against
          the configured regular expression.
        '';
      };
      separator = mkOption {
        type = types.str;
        default = ";";
        description = ''
          Separator placed between concatenated source label values.
        '';
      };
      target_label = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Label to which the resulting value is written in a replace action.
          It is mandatory for replace actions.
        '';
      };
      regex = mkOption {
        type = types.str;
        description = ''
          Regular expression against which the extracted value is matched.
        '';
      };
      replacement = mkOption {
        type = types.str;
        default = "";
        description = ''
          Replacement value against which a regex replace is performed if the
          regular expression matches.
        '';
      };
      action = mkOption {
        type = types.enum ["replace" "keep" "drop"];
        description = ''
          Action to perform based on regex matching.
        '';
      };
    };
  };

in {
  options = {
    services.prometheus = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the Prometheus monitoring daemon.
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = "0.0.0.0:9090";
        description = ''
          Address to listen on for the web interface, API, and telemetry.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/prometheus";
        description = ''
          Directory to store Prometheus metrics data.
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra commandline options when launching Prometheus.
        '';
      };

      globalConfig = mkOption {
        type = promTypes.globalConfig;
        default = {};
        apply = _filter;
        description = ''
          Parameters that are valid in all  configuration contexts. They
          also serve as defaults for other configuration sections
        '';
      };

      rules = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Alerting and/or Recording rules to evaluate at runtime.
        '';
      };

      ruleFiles = mkOption {
        type = types.listOf types.path;
        default = [];
        description = ''
          Any additional rules files to include in this configuration.
        '';
      };

      scrapeConfigs = mkOption {
        type = types.listOf promTypes.scrape_config;
        default = [];
        apply = x: map _filter x;
        description = ''
          A list of scrape configurations.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraGroups.${promGroup}.gid = config.ids.gids.prometheus;
    users.extraUsers.${promUser} = {
      description = "Prometheus daemon user";
      uid = config.ids.uids.prometheus;
      group = promGroup;
      home = cfg.dataDir;
      createHome = true;
    };
    systemd.services.prometheus = {
      wantedBy = [ "multi-user.target" ];
      after    = [ "network.target" ];
      script = ''
        #!/bin/sh
        exec ${pkgs.prometheus}/bin/prometheus \
          ${concatStringsSep " \\\n  " cmdlineArgs}
      '';
      serviceConfig = {
        User = promUser;
        Restart  = "always";
        WorkingDirectory = cfg.dataDir;
      };
    };
  };
}
