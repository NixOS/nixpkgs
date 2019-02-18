{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus;
  promUser = "prometheus";
  promGroup = "prometheus";
  isV1 = lib.versionOlder cfg.package.version "2";
  isV2 = lib.versionAtLeast cfg.package.version "2";

  # Get a submodule without any embedded metadata:
  _filter = x: filterAttrs (k: v: k != "_module") x;

  # a wrapper that verifies that the configuration is valid
  promtoolCheck = what: name: file: pkgs.runCommand "${name}-checked"
    { buildInputs = [ cfg.package ]; } ''
    ln -s ${file} $out
    promtool ${what} $out
  '';

  # Pretty-print JSON to a file
  writePrettyJSON = name: x:
    pkgs.runCommand name { } ''
      echo '${builtins.toJSON x}' | ${pkgs.jq}/bin/jq . > $out
    '';

  # This becomes the main config file
  promConfig = let
    cmd = if isV2 then "check rules" else "check-rules";
    in {
      global = cfg.globalConfig;
      rule_files = map (promtoolCheck cmd "rules") (cfg.ruleFiles ++ [
        (pkgs.writeText "prometheus.rules" (concatStringsSep "\n" cfg.rules))
      ]);
      scrape_configs = cfg.scrapeConfigs;
    } // optionalAttrs isV2 {
      alerting = cfg.alerting;
    };

  generatedPrometheusYml = writePrettyJSON "prometheus.yml" promConfig;

  prometheusYml = let
    cmd = if isV2 then "check config" else "check-config";
    yml =  if cfg.configText != null then
      pkgs.writeText "prometheus.yml" cfg.configText
      else generatedPrometheusYml;
    in promtoolCheck cmd "prometheus.yml" yml;

  cmdlineArgs =
    if isV2 then
      cfg.extraFlags ++ [
        "--storage.tsdb.path=${cfg.dataDir}/metrics"
        "--config.file=${prometheusYml}"
        "--web.listen-address=${cfg.listenAddress}"
        "--alertmanager.notification-queue-capacity=${toString cfg.alertmanagerNotificationQueueCapacity}"
        "--alertmanager.timeout=${toString cfg.alertmanagerTimeout}s"
        (optionalString (cfg.webExternalUrl != null) "--web.external-url=${cfg.webExternalUrl}")
      ]
    else
      cfg.extraFlags ++ [
        "-storage.local.path=${cfg.dataDir}/metrics"
        "-config.file=${prometheusYml}"
        "-web.listen-address=${cfg.listenAddress}"
        "-alertmanager.notification-queue-capacity=${toString cfg.alertmanagerNotificationQueueCapacity}"
        "-alertmanager.timeout=${toString cfg.alertmanagerTimeout}s"
        (optionalString (cfg.alertmanagerURL != []) "-alertmanager.url=${concatStringsSep "," cfg.alertmanagerURL}")
        (optionalString (cfg.webExternalUrl != null) "-web.external-url=${cfg.webExternalUrl}")
      ];

  promTypes.basic_auth = types.submodule {
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
  };

  promTypes.tls_config = types.submodule {
    options = {
      ca_file = mkOption {
        type = types.path;
        description = ''
          CA certificate to validate API server certificate with.
        '';
      };
      cert_file = mkOption {
        type = types.path;
        description = ''
          Certificate for client authentication to the server.
        '';
      };
      key_file = mkOption {
        type = types.path;
        description = ''
          Key for client authentication to the server.
        '';
      };
      server_name = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          ServerName extension to indicate the name of the server.
        '';
      };
      insecure_skip_verify = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Disable validation of the server certificate.
        '';
      };
    };
  };

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

      external_labels = mkOption {
        type = types.attrsOf types.str;
        description = ''
          The labels to add to any time series or alerts when
          communicating with external systems (federation, remote
          storage, Alertmanager).
        '';
        default = {};
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
      honor_labels = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Controls how Prometheus handles conflicts between labels
          that are already present in scraped data and labels that
          Prometheus would attach server-side ("job" and "instance"
          labels, manually configured target labels, and labels
          generated by service discovery implementations).

          If honor_labels is set to "true", label conflicts are
          resolved by keeping label values from the scraped data and
          ignoring the conflicting server-side labels.

          If honor_labels is set to "false", label conflicts are
          resolved by renaming conflicting labels in the scraped data
          to "exported_&lt;original-label&gt;" (for example
          "exported_instance", "exported_job") and then attaching
          server-side labels. This is useful for use cases such as
          federation, where all labels specified in the target should
          be preserved.
        '';
      };
      scheme = mkOption {
        type = types.enum ["http" "https"];
        default = "http";
        description = ''
          The URL scheme with which to fetch metrics from targets.
        '';
      };
      params = mkOption {
        type = types.attrsOf (types.listOf types.str);
        default = {};
        description = ''
          Optional HTTP URL parameters.
        '';
      };
      basic_auth = mkOption {
        type = types.nullOr promTypes.basic_auth;
        default = null;
        apply = x: mapNullable _filter x;
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
        default = {};
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
        type = with types; nullOr (listOf str);
        default = null;
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
        default = "(.*)";
        description = ''
          Regular expression against which the extracted value is matched.
        '';
      };
      replacement = mkOption {
        type = types.str;
        default = "$1";
        description = ''
          Replacement value against which a regex replace is performed if the
          regular expression matches.
        '';
      };
      action = mkOption {
        type = types.enum ["replace" "keep" "drop"];
        default = "replace";
        description = ''
          Action to perform based on regex matching.
        '';
      };
    };
  };

  promTypes.alertmanager_config = types.submodule {
    options = {
      timeout = mkOption {
        type = types.str;
        default = "10s";
        description = ''
          Per-target Alertmanager timeout when pushing alerts.
        '';
      };
      path_prefix = mkOption {
        type = types.str;
        default = "/";
        description = ''
          Prefix for the HTTP path alerts are pushed to.
        '';
      };
      scheme = mkOption {
        type = types.enum [ "http" "https" ];
        default = "http";
        description = ''
          Configures the protocol scheme used for requests.
        '';
      };
      basic_auth = mkOption {
        type = types.nullOr promTypes.basic_auth;
        default = null;
        apply = x: mapNullable _filter x;
        description = ''
          Sets the `Authorization` header on every remote read request with the
          configured username and password.
        '';
      };
      tls_config = mkOption {
        type = types.nullOr promTypes.tls_config;
        default = null;
        apply = x: mapNullable _filter x;
        description = ''
          Configures the scrape request's TLS settings.
        '';
      };
      proxy_url = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Optional proxy URL.
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
          List of labeled target groups.
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

in {
  options = {
    services.prometheus = {

      enable = mkEnableOption "Prometheus monitoring daemon";

      package = mkOption {
        type = types.package;
        default = pkgs.prometheus;
        defaultText = "pkgs.prometheus";
        description = ''
          The prometheus package that should be used.
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

      configText = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          If non-null, this option defines the text that is written to
          prometheus.yml. If null, the contents of prometheus.yml is generated
          from the structured config options.
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

      alertmanagerNotificationQueueCapacity = mkOption {
        type = types.int;
        default = 10000;
        description = ''
          The capacity of the queue for pending alert manager notifications.
        '';
      };

      alertmanagerTimeout = mkOption {
        type = types.int;
        default = 10;
        description = ''
          Alert manager HTTP API timeout (in seconds).
        '';
      };

      webExternalUrl = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "https://example.com/";
        description = ''
          The URL under which Prometheus is externally reachable (for example,
          if Prometheus is served via a reverse proxy).
        '';
      };

      alertmanagerURL = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          List of Alertmanager URLs to send notifications to.

          For prometheus 1.x.
        '';
      };

      alerting = {
        alert_relabel_configs = mkOption {
        type = types.listOf promTypes.relabel_config;
        default = [];
          apply = x: map _filter x;
          description = ''
            List of relabel configurations.

            For prometheus 2.x.
          '';
        };
        alertmanagers = mkOption {
          type = types.listOf promTypes.alertmanager_config;
          default = [];
          apply = x: map _filter x;
          description = ''
            Alertmanagers configuration.

            For prometheus 2.x.
         '';
        };
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      (mkIf isV2 {
        assertion = cfg.alertmanagerURL == [];
        message = ''
          `alertmanagerURL` option is only used with prometheus 1.x.
          Use `alerting` option for prometheus 2.x
        '';
      })
      (mkIf isV1 {
        assertion = cfg.alerting.alert_relabel_configs == [] && cfg.alerting.alertmanagers == [];
        message = ''
          `alerting` option is only used with prometheus 2.x.
          Use `alertmanagerURL` option for prometheus 1.x
        '';
      })
    ];

    users.groups.${promGroup}.gid = config.ids.gids.prometheus;
    users.users.${promUser} = {
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
        exec ${cfg.package}/bin/prometheus \
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
