{ config, pkgs, lib, ... }:

with lib;

let
  yaml = pkgs.formats.yaml { };
  cfg = config.services.prometheus;
  checkConfigEnabled =
    (lib.isBool cfg.checkConfig && cfg.checkConfig)
      || cfg.checkConfig == "syntax-only";

  workingDir = "/var/lib/" + cfg.stateDir;

  triggerReload = pkgs.writeShellScriptBin "trigger-reload-prometheus" ''
    PATH="${makeBinPath (with pkgs; [ systemd ])}"
    if systemctl -q is-active prometheus.service; then
      systemctl reload prometheus.service
    fi
  '';

  reload = pkgs.writeShellScriptBin "reload-prometheus" ''
    PATH="${makeBinPath (with pkgs; [ systemd coreutils gnugrep ])}"
    cursor=$(journalctl --show-cursor -n0 | grep -oP "cursor: \K.*")
    kill -HUP $MAINPID
    journalctl -u prometheus.service --after-cursor="$cursor" -f \
      | grep -m 1 "Completed loading of configuration file" > /dev/null
  '';

  # a wrapper that verifies that the configuration is valid
  promtoolCheck = what: name: file:
    if checkConfigEnabled then
      pkgs.runCommand "${name}-${replaceStrings [" "] [""] what}-checked" {
        preferLocalBuild = true;
        nativeBuildInputs = [ cfg.package.cli ];
      } ''
        ln -s ${file} $out
        promtool ${what} $out
      '' else file;

  generatedPrometheusYml = yaml.generate "prometheus.yml" promConfig;

  # This becomes the main config file for Prometheus
  promConfig = {
    global = filterValidPrometheus cfg.globalConfig;
    scrape_configs = filterValidPrometheus cfg.scrapeConfigs;
    remote_write = filterValidPrometheus cfg.remoteWrite;
    remote_read = filterValidPrometheus cfg.remoteRead;
    rule_files = optionals (!(cfg.enableAgentMode)) (map (promtoolCheck "check rules" "rules") (cfg.ruleFiles ++ [
      (pkgs.writeText "prometheus.rules" (concatStringsSep "\n" cfg.rules))
    ]));
    alerting = {
      inherit (cfg) alertmanagers;
    };
  };

  prometheusYml =
    let
      yml =
        if cfg.configText != null then
          pkgs.writeText "prometheus.yml" cfg.configText
        else generatedPrometheusYml;
    in
    promtoolCheck "check config ${lib.optionalString (cfg.checkConfig == "syntax-only") "--syntax-only"}" "prometheus.yml" yml;

  cmdlineArgs = cfg.extraFlags ++ [
    "--config.file=${
      if cfg.enableReload
      then "/etc/prometheus/prometheus.yaml"
      else prometheusYml
    }"
    "--web.listen-address=${cfg.listenAddress}:${builtins.toString cfg.port}"
  ] ++ (
    if (cfg.enableAgentMode) then [
      "--enable-feature=agent"
    ] else [
       "--alertmanager.notification-queue-capacity=${toString cfg.alertmanagerNotificationQueueCapacity }"
       "--storage.tsdb.path=${workingDir}/data/"
    ])
    ++ optional (cfg.webExternalUrl != null) "--web.external-url=${cfg.webExternalUrl}"
    ++ optional (cfg.retentionTime != null) "--storage.tsdb.retention.time=${cfg.retentionTime}"
    ++ optional (cfg.webConfigFile != null) "--web.config.file=${cfg.webConfigFile}";

  filterValidPrometheus = filterAttrsListRecursive (n: v: !(n == "_module" || v == null));
  filterAttrsListRecursive = pred: x:
    if isAttrs x then
      listToAttrs
        (
          concatMap
            (name:
              let v = x.${name}; in
              if pred name v then [
                (nameValuePair name (filterAttrsListRecursive pred v))
              ] else [ ]
            )
            (attrNames x)
        )
    else if isList x then
      map (filterAttrsListRecursive pred) x
    else x;

  #
  # Config types: helper functions
  #

  mkDefOpt = type: defaultStr: description: mkOpt type (description + ''

    Defaults to ````${defaultStr}```` in prometheus
    when set to `null`.
  '');

  mkOpt = type: description: mkOption {
    type = types.nullOr type;
    default = null;
    description = description;
  };

  mkSdConfigModule = extraOptions: types.submodule {
    options = {
      basic_auth = mkOpt promTypes.basic_auth ''
        Optional HTTP basic authentication information.
      '';

      authorization = mkOpt
        (types.submodule {
          options = {
            type = mkDefOpt types.str "Bearer" ''
              Sets the authentication type.
            '';

            credentials = mkOpt types.str ''
              Sets the credentials. It is mutually exclusive with `credentials_file`.
            '';

            credentials_file = mkOpt types.str ''
              Sets the credentials to the credentials read from the configured file.
              It is mutually exclusive with `credentials`.
            '';
          };
        }) ''
        Optional `Authorization` header configuration.
      '';

      oauth2 = mkOpt promtypes.oauth2 ''
        Optional OAuth 2.0 configuration.
        Cannot be used at the same time as basic_auth or authorization.
      '';

      proxy_url = mkOpt types.str ''
        Optional proxy URL.
      '';

      follow_redirects = mkDefOpt types.bool "true" ''
        Configure whether HTTP requests follow HTTP 3xx redirects.
      '';

      tls_config = mkOpt promTypes.tls_config ''
        TLS configuration.
      '';
    } // extraOptions;
  };

  #
  # Config types: general
  #

  promTypes.globalConfig = types.submodule {
    options = {
      scrape_interval = mkDefOpt types.str "1m" ''
        How frequently to scrape targets by default.
      '';

      scrape_timeout = mkDefOpt types.str "10s" ''
        How long until a scrape request times out.
      '';

      evaluation_interval = mkDefOpt types.str "1m" ''
        How frequently to evaluate rules by default.
      '';

      external_labels = mkOpt (types.attrsOf types.str) ''
        The labels to add to any time series or alerts when
        communicating with external systems (federation, remote
        storage, Alertmanager).
      '';

      query_log_file = mkOpt types.str ''
        Path to the file prometheus should write its query log to.
      '';
    };
  };

  promTypes.basic_auth = types.submodule {
    options = {
      username = mkOption {
        type = types.str;
        description = ''
          HTTP username
        '';
      };
      password = mkOpt types.str "HTTP password";
      password_file = mkOpt types.str "HTTP password file";
    };
  };

  promTypes.sigv4 = types.submodule {
    options = {
      region = mkOpt types.str ''
        The AWS region.
      '';
      access_key = mkOpt types.str ''
        The Access Key ID.
      '';
      secret_key = mkOpt types.str ''
        The Secret Access Key.
      '';
      profile = mkOpt types.str ''
        The named AWS profile used to authenticate.
      '';
      role_arn = mkOpt types.str ''
        The AWS role ARN.
      '';
    };
  };

  promTypes.tls_config = types.submodule {
    options = {
      ca_file = mkOpt types.str ''
        CA certificate to validate API server certificate with.
      '';

      cert_file = mkOpt types.str ''
        Certificate file for client cert authentication to the server.
      '';

      key_file = mkOpt types.str ''
        Key file for client cert authentication to the server.
      '';

      server_name = mkOpt types.str ''
        ServerName extension to indicate the name of the server.
        http://tools.ietf.org/html/rfc4366#section-3.1
      '';

      insecure_skip_verify = mkOpt types.bool ''
        Disable validation of the server certificate.
      '';
    };
  };

  promtypes.oauth2 = types.submodule {
    options = {
      client_id = mkOpt types.str ''
        OAuth client ID.
      '';

      client_secret = mkOpt types.str ''
        OAuth client secret.
      '';

      client_secret_file = mkOpt types.str ''
        Read the client secret from a file. It is mutually exclusive with `client_secret`.
      '';

      scopes = mkOpt (types.listOf types.str) ''
        Scopes for the token request.
      '';

      token_url = mkOpt types.str ''
        The URL to fetch the token from.
      '';

      endpoint_params = mkOpt (types.attrsOf types.str) ''
        Optional parameters to append to the token URL.
      '';
    };
  };

  # https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config
  promTypes.scrape_config = types.submodule {
    options = {
      authorization = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = ''
          Sets the `Authorization` header on every scrape request with the configured credentials.
        '';
      };
      job_name = mkOption {
        type = types.str;
        description = ''
          The job name assigned to scraped metrics by default.
        '';
      };
      scrape_interval = mkOpt types.str ''
        How frequently to scrape targets from this job. Defaults to the
        globally configured default.
      '';

      scrape_timeout = mkOpt types.str ''
        Per-target timeout when scraping this job. Defaults to the
        globally configured default.
      '';

      scrape_protocols = mkOpt (types.listOf types.str) ''
        The protocols to negotiate during a scrape with the client.
      '';

      fallback_scrape_protocol = mkOpt types.str ''
        Fallback protocol to use if a scrape returns blank, unparseable, or otherwise
        invalid Content-Type.
      '';

      metrics_path = mkDefOpt types.str "/metrics" ''
        The HTTP resource path on which to fetch metrics from targets.
      '';

      honor_labels = mkDefOpt types.bool "false" ''
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
        to "exported_\<original-label\>" (for example
        "exported_instance", "exported_job") and then attaching
        server-side labels. This is useful for use cases such as
        federation, where all labels specified in the target should
        be preserved.
      '';

      honor_timestamps = mkDefOpt types.bool "true" ''
        honor_timestamps controls whether Prometheus respects the timestamps present
        in scraped data.

        If honor_timestamps is set to `true`, the timestamps of the metrics exposed
        by the target will be used.

        If honor_timestamps is set to `false`, the timestamps of the metrics exposed
        by the target will be ignored.
      '';

      scheme = mkDefOpt (types.enum [ "http" "https" ]) "http" ''
        The URL scheme with which to fetch metrics from targets.
      '';

      params = mkOpt (types.attrsOf (types.listOf types.str)) ''
        Optional HTTP URL parameters.
      '';

      basic_auth = mkOpt promTypes.basic_auth ''
        Sets the `Authorization` header on every scrape request with the
        configured username and password.
        password and password_file are mutually exclusive.
      '';

      bearer_token = mkOpt types.str ''
        Sets the `Authorization` header on every scrape request with
        the configured bearer token. It is mutually exclusive with
        {option}`bearer_token_file`.
      '';

      bearer_token_file = mkOpt types.str ''
        Sets the `Authorization` header on every scrape request with
        the bearer token read from the configured file. It is mutually
        exclusive with {option}`bearer_token`.
      '';

      tls_config = mkOpt promTypes.tls_config ''
        Configures the scrape request's TLS settings.
      '';

      proxy_url = mkOpt types.str ''
        Optional proxy URL.
      '';

      azure_sd_configs = mkOpt (types.listOf promTypes.azure_sd_config) ''
        List of Azure service discovery configurations.
      '';

      consul_sd_configs = mkOpt (types.listOf promTypes.consul_sd_config) ''
        List of Consul service discovery configurations.
      '';

      digitalocean_sd_configs = mkOpt (types.listOf promTypes.digitalocean_sd_config) ''
        List of DigitalOcean service discovery configurations.
      '';

      docker_sd_configs = mkOpt (types.listOf promTypes.docker_sd_config) ''
        List of Docker service discovery configurations.
      '';

      dockerswarm_sd_configs = mkOpt (types.listOf promTypes.dockerswarm_sd_config) ''
        List of Docker Swarm service discovery configurations.
      '';

      dns_sd_configs = mkOpt (types.listOf promTypes.dns_sd_config) ''
        List of DNS service discovery configurations.
      '';

      ec2_sd_configs = mkOpt (types.listOf promTypes.ec2_sd_config) ''
        List of EC2 service discovery configurations.
      '';

      eureka_sd_configs = mkOpt (types.listOf promTypes.eureka_sd_config) ''
        List of Eureka service discovery configurations.
      '';

      file_sd_configs = mkOpt (types.listOf promTypes.file_sd_config) ''
        List of file service discovery configurations.
      '';

      gce_sd_configs = mkOpt (types.listOf promTypes.gce_sd_config) ''
        List of Google Compute Engine service discovery configurations.

        See [the relevant Prometheus configuration docs](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#gce_sd_config)
        for more detail.
      '';

      hetzner_sd_configs = mkOpt (types.listOf promTypes.hetzner_sd_config) ''
        List of Hetzner service discovery configurations.
      '';

      http_sd_configs = mkOpt (types.listOf promTypes.http_sd_config) ''
        List of HTTP service discovery configurations.
      '';

      kubernetes_sd_configs = mkOpt (types.listOf promTypes.kubernetes_sd_config) ''
        List of Kubernetes service discovery configurations.
      '';

      kuma_sd_configs = mkOpt (types.listOf promTypes.kuma_sd_config) ''
        List of Kuma service discovery configurations.
      '';

      lightsail_sd_configs = mkOpt (types.listOf promTypes.lightsail_sd_config) ''
        List of Lightsail service discovery configurations.
      '';

      linode_sd_configs = mkOpt (types.listOf promTypes.linode_sd_config) ''
        List of Linode service discovery configurations.
      '';

      marathon_sd_configs = mkOpt (types.listOf promTypes.marathon_sd_config) ''
        List of Marathon service discovery configurations.
      '';

      nerve_sd_configs = mkOpt (types.listOf promTypes.nerve_sd_config) ''
        List of AirBnB's Nerve service discovery configurations.
      '';

      openstack_sd_configs = mkOpt (types.listOf promTypes.openstack_sd_config) ''
        List of OpenStack service discovery configurations.
      '';

      puppetdb_sd_configs = mkOpt (types.listOf promTypes.puppetdb_sd_config) ''
        List of PuppetDB service discovery configurations.
      '';

      scaleway_sd_configs = mkOpt (types.listOf promTypes.scaleway_sd_config) ''
        List of Scaleway service discovery configurations.
      '';

      serverset_sd_configs = mkOpt (types.listOf promTypes.serverset_sd_config) ''
        List of Zookeeper Serverset service discovery configurations.
      '';

      triton_sd_configs = mkOpt (types.listOf promTypes.triton_sd_config) ''
        List of Triton Serverset service discovery configurations.
      '';

      uyuni_sd_configs = mkOpt (types.listOf promTypes.uyuni_sd_config) ''
        List of Uyuni Serverset service discovery configurations.
      '';

      static_configs = mkOpt (types.listOf promTypes.static_config) ''
        List of labeled target groups for this job.
      '';

      relabel_configs = mkOpt (types.listOf promTypes.relabel_config) ''
        List of relabel configurations.
      '';

      metric_relabel_configs = mkOpt (types.listOf promTypes.relabel_config) ''
        List of metric relabel configurations.
      '';

      body_size_limit = mkDefOpt types.str "0" ''
        An uncompressed response body larger than this many bytes will cause the
        scrape to fail. 0 means no limit. Example: 100MB.
        This is an experimental feature, this behaviour could
        change or be removed in the future.
      '';

      sample_limit = mkDefOpt types.int "0" ''
        Per-scrape limit on number of scraped samples that will be accepted.
        If more than this number of samples are present after metric relabelling
        the entire scrape will be treated as failed. 0 means no limit.
      '';

      label_limit = mkDefOpt types.int "0" ''
        Per-scrape limit on number of labels that will be accepted for a sample. If
        more than this number of labels are present post metric-relabeling, the
        entire scrape will be treated as failed. 0 means no limit.
      '';

      label_name_length_limit = mkDefOpt types.int "0" ''
        Per-scrape limit on length of labels name that will be accepted for a sample.
        If a label name is longer than this number post metric-relabeling, the entire
        scrape will be treated as failed. 0 means no limit.
      '';

      label_value_length_limit = mkDefOpt types.int "0" ''
        Per-scrape limit on length of labels value that will be accepted for a sample.
        If a label value is longer than this number post metric-relabeling, the
        entire scrape will be treated as failed. 0 means no limit.
      '';

      target_limit = mkDefOpt types.int "0" ''
        Per-scrape config limit on number of unique targets that will be
        accepted. If more than this number of targets are present after target
        relabeling, Prometheus will mark the targets as failed without scraping them.
        0 means no limit. This is an experimental feature, this behaviour could
        change in the future.
      '';
    };
  };

  #
  # Config types: service discovery
  #

  # For this one, the docs actually define all types needed to use mkSdConfigModule, but a bunch
  # of them are marked with 'currently not support by Azure' so we don't bother adding them in
  # here.
  promTypes.azure_sd_config = types.submodule {
    options = {
      environment = mkDefOpt types.str "AzurePublicCloud" ''
        The Azure environment.
      '';

      authentication_method = mkDefOpt (types.enum [ "OAuth" "ManagedIdentity" ]) "OAuth" ''
        The authentication method, either OAuth or ManagedIdentity.
        See https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview
      '';

      subscription_id = mkOption {
        type = types.str;
        description = ''
          The subscription ID.
        '';
      };

      tenant_id = mkOpt types.str ''
        Optional tenant ID. Only required with authentication_method OAuth.
      '';

      client_id = mkOpt types.str ''
        Optional client ID. Only required with authentication_method OAuth.
      '';

      client_secret = mkOpt types.str ''
        Optional client secret. Only required with authentication_method OAuth.
      '';

      refresh_interval = mkDefOpt types.str "300s" ''
        Refresh interval to re-read the instance list.
      '';

      port = mkDefOpt types.port "80" ''
        The port to scrape metrics from. If using the public IP
        address, this must instead be specified in the relabeling
        rule.
      '';

      proxy_url = mkOpt types.str ''
        Optional proxy URL.
      '';

      follow_redirects = mkDefOpt types.bool "true" ''
        Configure whether HTTP requests follow HTTP 3xx redirects.
      '';

      tls_config = mkOpt promTypes.tls_config ''
        TLS configuration.
      '';
    };
  };

  promTypes.consul_sd_config = mkSdConfigModule {
    server = mkDefOpt types.str "localhost:8500" ''
      Consul server to query.
    '';

    token = mkOpt types.str "Consul token";

    datacenter = mkOpt types.str "Consul datacenter";

    scheme = mkDefOpt types.str "http" "Consul scheme";

    username = mkOpt types.str "Consul username";

    password = mkOpt types.str "Consul password";

    tls_config = mkOpt promTypes.tls_config ''
      Configures the Consul request's TLS settings.
    '';

    services = mkOpt (types.listOf types.str) ''
      A list of services for which targets are retrieved.
    '';

    tags = mkOpt (types.listOf types.str) ''
      An optional list of tags used to filter nodes for a given
      service. Services must contain all tags in the list.
    '';

    node_meta = mkOpt (types.attrsOf types.str) ''
      Node metadata used to filter nodes for a given service.
    '';

    tag_separator = mkDefOpt types.str "," ''
      The string by which Consul tags are joined into the tag label.
    '';

    allow_stale = mkOpt types.bool ''
      Allow stale Consul results
      (see <https://www.consul.io/api/index.html#consistency-modes>).

      Will reduce load on Consul.
    '';

    refresh_interval = mkDefOpt types.str "30s" ''
      The time after which the provided names are refreshed.

      On large setup it might be a good idea to increase this value
      because the catalog will change all the time.
    '';
  };

  promTypes.digitalocean_sd_config = mkSdConfigModule {
    port = mkDefOpt types.port "80" ''
      The port to scrape metrics from.
    '';

    refresh_interval = mkDefOpt types.str "60s" ''
      The time after which the droplets are refreshed.
    '';
  };

  mkDockerSdConfigModule = extraOptions: mkSdConfigModule ({
    host = mkOption {
      type = types.str;
      description = ''
        Address of the Docker daemon.
      '';
    };

    port = mkDefOpt types.port "80" ''
      The port to scrape metrics from, when `role` is nodes, and for discovered
      tasks and services that don't have published ports.
    '';

    filters = mkOpt
      (types.listOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = ''
              Name of the filter. The available filters are listed in the upstream documentation:
              Services: <https://docs.docker.com/engine/api/v1.40/#operation/ServiceList>
              Tasks: <https://docs.docker.com/engine/api/v1.40/#operation/TaskList>
              Nodes: <https://docs.docker.com/engine/api/v1.40/#operation/NodeList>
            '';
          };
          values = mkOption {
            type = types.str;
            description = ''
              Value for the filter.
            '';
          };
        };
      })) ''
      Optional filters to limit the discovery process to a subset of available resources.
    '';

    refresh_interval = mkDefOpt types.str "60s" ''
      The time after which the containers are refreshed.
    '';
  } // extraOptions);

  promTypes.docker_sd_config = mkDockerSdConfigModule {
    host_networking_host = mkDefOpt types.str "localhost" ''
      The host to use if the container is in host networking mode.
    '';
  };

  promTypes.dockerswarm_sd_config = mkDockerSdConfigModule {
    role = mkOption {
      type = types.enum [ "services" "tasks" "nodes" ];
      description = ''
        Role of the targets to retrieve. Must be `services`, `tasks`, or `nodes`.
      '';
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

      type = mkDefOpt (types.enum [ "SRV" "A" "AAAA" ]) "SRV" ''
        The type of DNS query to perform. One of SRV, A, or AAAA.
      '';

      port = mkOpt types.port ''
        The port number used if the query type is not SRV.
      '';

      refresh_interval = mkDefOpt types.str "30s" ''
        The time after which the provided names are refreshed.
      '';
    };
  };

  promTypes.ec2_sd_config = types.submodule {
    options = {
      region = mkOption {
        type = types.str;
        description = ''
          The AWS Region. If blank, the region from the instance metadata is used.
        '';
      };
      endpoint = mkOpt types.str ''
        Custom endpoint to be used.
      '';

      access_key = mkOpt types.str ''
        The AWS API key id. If blank, the environment variable
        `AWS_ACCESS_KEY_ID` is used.
      '';

      secret_key = mkOpt types.str ''
        The AWS API key secret. If blank, the environment variable
         `AWS_SECRET_ACCESS_KEY` is used.
      '';

      profile = mkOpt types.str ''
        Named AWS profile used to connect to the API.
      '';

      role_arn = mkOpt types.str ''
        AWS Role ARN, an alternative to using AWS API keys.
      '';

      refresh_interval = mkDefOpt types.str "60s" ''
        Refresh interval to re-read the instance list.
      '';

      port = mkDefOpt types.port "80" ''
        The port to scrape metrics from. If using the public IP
        address, this must instead be specified in the relabeling
        rule.
      '';

      filters = mkOpt
        (types.listOf (types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              description = ''
                See [this list](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeInstances.html)
                for the available filters.
              '';
            };

            values = mkOption {
              type = types.listOf types.str;
              default = [ ];
              description = ''
                Value of the filter.
              '';
            };
          };
        })) ''
        Filters can be used optionally to filter the instance list by other criteria.
      '';
    };
  };

  promTypes.eureka_sd_config = mkSdConfigModule {
    server = mkOption {
      type = types.str;
      description = ''
        The URL to connect to the Eureka server.
      '';
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

      refresh_interval = mkDefOpt types.str "5m" ''
        Refresh interval to re-read the files.
      '';
    };
  };

  promTypes.gce_sd_config = types.submodule {
    options = {
      # Use `mkOption` instead of `mkOpt` for project and zone because they are
      # required configuration values for `gce_sd_config`.
      project = mkOption {
        type = types.str;
        description = ''
          The GCP Project.
        '';
      };

      zone = mkOption {
        type = types.str;
        description = ''
          The zone of the scrape targets. If you need multiple zones use multiple
          gce_sd_configs.
        '';
      };

      filter = mkOpt types.str ''
        Filter can be used optionally to filter the instance list by other
        criteria Syntax of this filter string is described here in the filter
        query parameter section: <https://cloud.google.com/compute/docs/reference/latest/instances/list>.
      '';

      refresh_interval = mkDefOpt types.str "60s" ''
        Refresh interval to re-read the cloud instance list.
      '';

      port = mkDefOpt types.port "80" ''
        The port to scrape metrics from. If using the public IP address, this
        must instead be specified in the relabeling rule.
      '';

      tag_separator = mkDefOpt types.str "," ''
        The tag separator used to separate concatenated GCE instance network tags.

        See the GCP documentation on network tags for more information:
        <https://cloud.google.com/vpc/docs/add-remove-network-tags>
      '';
    };
  };

  promTypes.hetzner_sd_config = mkSdConfigModule {
    role = mkOption {
      type = types.enum [ "robot" "hcloud" ];
      description = ''
        The Hetzner role of entities that should be discovered.
        One of `robot` or `hcloud`.
      '';
    };

    port = mkDefOpt types.port "80" ''
      The port to scrape metrics from.
    '';

    refresh_interval = mkDefOpt types.str "60s" ''
      The time after which the servers are refreshed.
    '';
  };

  promTypes.http_sd_config = types.submodule {
    options = {
      url = mkOption {
        type = types.str;
        description = ''
          URL from which the targets are fetched.
        '';
      };

      refresh_interval = mkDefOpt types.str "60s" ''
        Refresh interval to re-query the endpoint.
      '';

      basic_auth = mkOpt promTypes.basic_auth ''
        Authentication information used to authenticate to the API server.
        password and password_file are mutually exclusive.
      '';

      proxy_url = mkOpt types.str ''
        Optional proxy URL.
      '';

      follow_redirects = mkDefOpt types.bool "true" ''
        Configure whether HTTP requests follow HTTP 3xx redirects.
      '';

      tls_config = mkOpt promTypes.tls_config ''
        Configures the scrape request's TLS settings.
      '';
    };
  };

  promTypes.kubernetes_sd_config = mkSdConfigModule {
    api_server = mkOpt types.str ''
      The API server addresses. If left empty, Prometheus is assumed to run inside
      of the cluster and will discover API servers automatically and use the pod's
      CA certificate and bearer token file at /var/run/secrets/kubernetes.io/serviceaccount/.
    '';

    role = mkOption {
      type = types.enum [ "endpoints" "service" "pod" "node" "ingress" ];
      description = ''
        The Kubernetes role of entities that should be discovered.
        One of endpoints, service, pod, node, or ingress.
      '';
    };

    kubeconfig_file = mkOpt types.str ''
      Optional path to a kubeconfig file.
      Note that api_server and kube_config are mutually exclusive.
    '';

    namespaces = mkOpt
      (
        types.submodule {
          options = {
            names = mkOpt (types.listOf types.str) ''
              Namespace name.
            '';
          };
        }
      ) ''
      Optional namespace discovery. If omitted, all namespaces are used.
    '';

    selectors = mkOpt
      (
        types.listOf (
          types.submodule {
            options = {
              role = mkOption {
                type = types.str;
                description = ''
                  Selector role
                '';
              };

              label = mkOpt types.str ''
                Selector label
              '';

              field = mkOpt types.str ''
                Selector field
              '';
            };
          }
        )
      ) ''
      Optional label and field selectors to limit the discovery process to a subset of available resources.
      See https://kubernetes.io/docs/concepts/overview/working-with-objects/field-selectors/
      and https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ to learn more about the possible
      filters that can be used. Endpoints role supports pod, service and endpoints selectors, other roles
      only support selectors matching the role itself (e.g. node role can only contain node selectors).

      Note: When making decision about using field/label selector make sure that this
      is the best approach - it will prevent Prometheus from reusing single list/watch
      for all scrape configs. This might result in a bigger load on the Kubernetes API,
      because per each selector combination there will be additional LIST/WATCH. On the other hand,
      if you just want to monitor small subset of pods in large cluster it's recommended to use selectors.
      Decision, if selectors should be used or not depends on the particular situation.
    '';
  };

  promTypes.kuma_sd_config = mkSdConfigModule {
    server = mkOption {
      type = types.str;
      description = ''
        Address of the Kuma Control Plane's MADS xDS server.
      '';
    };

    refresh_interval = mkDefOpt types.str "30s" ''
      The time to wait between polling update requests.
    '';

    fetch_timeout = mkDefOpt types.str "2m" ''
      The time after which the monitoring assignments are refreshed.
    '';
  };

  promTypes.lightsail_sd_config = types.submodule {
    options = {
      region = mkOpt types.str ''
        The AWS region. If blank, the region from the instance metadata is used.
      '';

      endpoint = mkOpt types.str ''
        Custom endpoint to be used.
      '';

      access_key = mkOpt types.str ''
        The AWS API keys. If blank, the environment variable `AWS_ACCESS_KEY_ID` is used.
      '';

      secret_key = mkOpt types.str ''
        The AWS API keys. If blank, the environment variable `AWS_SECRET_ACCESS_KEY` is used.
      '';

      profile = mkOpt types.str ''
        Named AWS profile used to connect to the API.
      '';

      role_arn = mkOpt types.str ''
        AWS Role ARN, an alternative to using AWS API keys.
      '';

      refresh_interval = mkDefOpt types.str "60s" ''
        Refresh interval to re-read the instance list.
      '';

      port = mkDefOpt types.port "80" ''
        The port to scrape metrics from. If using the public IP address, this must
        instead be specified in the relabeling rule.
      '';
    };
  };

  promTypes.linode_sd_config = mkSdConfigModule {
    port = mkDefOpt types.port "80" ''
      The port to scrape metrics from.
    '';

    tag_separator = mkDefOpt types.str "," ''
      The string by which Linode Instance tags are joined into the tag label.
    '';

    refresh_interval = mkDefOpt types.str "60s" ''
      The time after which the linode instances are refreshed.
    '';
  };

  promTypes.marathon_sd_config = mkSdConfigModule {
    servers = mkOption {
      type = types.listOf types.str;
      description = ''
        List of URLs to be used to contact Marathon servers. You need to provide at least one server URL.
      '';
    };

    refresh_interval = mkDefOpt types.str "30s" ''
      Polling interval.
    '';

    auth_token = mkOpt types.str ''
      Optional authentication information for token-based authentication:
      <https://docs.mesosphere.com/1.11/security/ent/iam-api/#passing-an-authentication-token>
      It is mutually exclusive with `auth_token_file` and other authentication mechanisms.
    '';

    auth_token_file = mkOpt types.str ''
      Optional authentication information for token-based authentication:
      <https://docs.mesosphere.com/1.11/security/ent/iam-api/#passing-an-authentication-token>
      It is mutually exclusive with `auth_token` and other authentication mechanisms.
    '';
  };

  promTypes.nerve_sd_config = types.submodule {
    options = {
      servers = mkOption {
        type = types.listOf types.str;
        description = ''
          The Zookeeper servers.
        '';
      };

      paths = mkOption {
        type = types.listOf types.str;
        description = ''
          Paths can point to a single service, or the root of a tree of services.
        '';
      };

      timeout = mkDefOpt types.str "10s" ''
        Timeout value.
      '';
    };
  };

  promTypes.openstack_sd_config = types.submodule {
    options =
      let
        userDescription = ''
          username is required if using Identity V2 API. Consult with your provider's
          control panel to discover your account's username. In Identity V3, either
          userid or a combination of username and domain_id or domain_name are needed.
        '';

        domainDescription = ''
          At most one of domain_id and domain_name must be provided if using username
          with Identity V3. Otherwise, either are optional.
        '';

        projectDescription = ''
          The project_id and project_name fields are optional for the Identity V2 API.
          Some providers allow you to specify a project_name instead of the project_id.
          Some require both. Your provider's authentication policies will determine
          how these fields influence authentication.
        '';

        applicationDescription = ''
          The application_credential_id or application_credential_name fields are
          required if using an application credential to authenticate. Some providers
          allow you to create an application credential to authenticate rather than a
          password.
        '';
      in
      {
        role = mkOption {
          type = types.str;
          description = ''
            The OpenStack role of entities that should be discovered.
          '';
        };

        region = mkOption {
          type = types.str;
          description = ''
            The OpenStack Region.
          '';
        };

        identity_endpoint = mkOpt types.str ''
          identity_endpoint specifies the HTTP endpoint that is required to work with
          the Identity API of the appropriate version. While it's ultimately needed by
          all of the identity services, it will often be populated by a provider-level
          function.
        '';

        username = mkOpt types.str userDescription;
        userid = mkOpt types.str userDescription;

        password = mkOpt types.str ''
          password for the Identity V2 and V3 APIs. Consult with your provider's
          control panel to discover your account's preferred method of authentication.
        '';

        domain_name = mkOpt types.str domainDescription;
        domain_id = mkOpt types.str domainDescription;

        project_name = mkOpt types.str projectDescription;
        project_id = mkOpt types.str projectDescription;

        application_credential_name = mkOpt types.str applicationDescription;
        application_credential_id = mkOpt types.str applicationDescription;

        application_credential_secret = mkOpt types.str ''
          The application_credential_secret field is required if using an application
          credential to authenticate.
        '';

        all_tenants = mkDefOpt types.bool "false" ''
          Whether the service discovery should list all instances for all projects.
          It is only relevant for the 'instance' role and usually requires admin permissions.
        '';

        refresh_interval = mkDefOpt types.str "60s" ''
          Refresh interval to re-read the instance list.
        '';

        port = mkDefOpt types.port "80" ''
          The port to scrape metrics from. If using the public IP address, this must
          instead be specified in the relabeling rule.
        '';

        availability = mkDefOpt (types.enum [ "public" "admin" "internal" ]) "public" ''
          The availability of the endpoint to connect to. Must be one of public, admin or internal.
        '';

        tls_config = mkOpt promTypes.tls_config ''
          TLS configuration.
        '';
      };
  };

  promTypes.puppetdb_sd_config = mkSdConfigModule {
    url = mkOption {
      type = types.str;
      description = ''
        The URL of the PuppetDB root query endpoint.
      '';
    };

    query = mkOption {
      type = types.str;
      description = ''
        Puppet Query Language (PQL) query. Only resources are supported.
        https://puppet.com/docs/puppetdb/latest/api/query/v4/pql.html
      '';
    };

    include_parameters = mkDefOpt types.bool "false" ''
      Whether to include the parameters as meta labels.
      Due to the differences between parameter types and Prometheus labels,
      some parameters might not be rendered. The format of the parameters might
      also change in future releases.

      Note: Enabling this exposes parameters in the Prometheus UI and API. Make sure
      that you don't have secrets exposed as parameters if you enable this.
    '';

    refresh_interval = mkDefOpt types.str "60s" ''
      Refresh interval to re-read the resources list.
    '';

    port = mkDefOpt types.port "80" ''
      The port to scrape metrics from.
    '';
  };

  promTypes.scaleway_sd_config = types.submodule {
    options = {
      access_key = mkOption {
        type = types.str;
        description = ''
          Access key to use. https://console.scaleway.com/project/credentials
        '';
      };

      secret_key = mkOpt types.str ''
        Secret key to use when listing targets. https://console.scaleway.com/project/credentials
        It is mutually exclusive with `secret_key_file`.
      '';

      secret_key_file = mkOpt types.str ''
        Sets the secret key with the credentials read from the configured file.
        It is mutually exclusive with `secret_key`.
      '';

      project_id = mkOption {
        type = types.str;
        description = ''
          Project ID of the targets.
        '';
      };

      role = mkOption {
        type = types.enum [ "instance" "baremetal" ];
        description = ''
          Role of the targets to retrieve. Must be `instance` or `baremetal`.
        '';
      };

      port = mkDefOpt types.port "80" ''
        The port to scrape metrics from.
      '';

      api_url = mkDefOpt types.str "https://api.scaleway.com" ''
        API URL to use when doing the server listing requests.
      '';

      zone = mkDefOpt types.str "fr-par-1" ''
        Zone is the availability zone of your targets (e.g. fr-par-1).
      '';

      name_filter = mkOpt types.str ''
        Specify a name filter (works as a LIKE) to apply on the server listing request.
      '';

      tags_filter = mkOpt (types.listOf types.str) ''
        Specify a tag filter (a server needs to have all defined tags to be listed) to apply on the server listing request.
      '';

      refresh_interval = mkDefOpt types.str "60s" ''
        Refresh interval to re-read the managed targets list.
      '';

      proxy_url = mkOpt types.str ''
        Optional proxy URL.
      '';

      follow_redirects = mkDefOpt types.bool "true" ''
        Configure whether HTTP requests follow HTTP 3xx redirects.
      '';

      tls_config = mkOpt promTypes.tls_config ''
        TLS configuration.
      '';
    };
  };

  # These are exactly the same.
  promTypes.serverset_sd_config = promTypes.nerve_sd_config;

  promTypes.triton_sd_config = types.submodule {
    options = {
      account = mkOption {
        type = types.str;
        description = ''
          The account to use for discovering new targets.
        '';
      };

      role = mkDefOpt (types.enum [ "container" "cn" ]) "container" ''
        The type of targets to discover, can be set to:
        - "container" to discover virtual machines (SmartOS zones, lx/KVM/bhyve branded zones) running on Triton
        - "cn" to discover compute nodes (servers/global zones) making up the Triton infrastructure
      '';

      dns_suffix = mkOption {
        type = types.str;
        description = ''
          The DNS suffix which should be applied to target.
        '';
      };

      endpoint = mkOption {
        type = types.str;
        description = ''
          The Triton discovery endpoint (e.g. `cmon.us-east-3b.triton.zone`). This is
          often the same value as dns_suffix.
        '';
      };

      groups = mkOpt (types.listOf types.str) ''
        A list of groups for which targets are retrieved, only supported when targeting the `container` role.
        If omitted all containers owned by the requesting account are scraped.
      '';

      port = mkDefOpt types.port "9163" ''
        The port to use for discovery and metric scraping.
      '';

      refresh_interval = mkDefOpt types.str "60s" ''
        The interval which should be used for refreshing targets.
      '';

      version = mkDefOpt types.int "1" ''
        The Triton discovery API version.
      '';

      tls_config = mkOpt promTypes.tls_config ''
        TLS configuration.
      '';
    };
  };

  promTypes.uyuni_sd_config = mkSdConfigModule {
    server = mkOption {
      type = types.str;
      description = ''
        The URL to connect to the Uyuni server.
      '';
    };

    username = mkOption {
      type = types.str;
      description = ''
        Credentials are used to authenticate the requests to Uyuni API.
      '';
    };

    password = mkOption {
      type = types.str;
      description = ''
        Credentials are used to authenticate the requests to Uyuni API.
      '';
    };

    entitlement = mkDefOpt types.str "monitoring_entitled" ''
      The entitlement string to filter eligible systems.
    '';

    separator = mkDefOpt types.str "," ''
      The string by which Uyuni group names are joined into the groups label
    '';

    refresh_interval = mkDefOpt types.str "60s" ''
      Refresh interval to re-read the managed targets list.
    '';
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
        default = { };
        description = ''
          Labels assigned to all metrics scraped from the targets.
        '';
      };
    };
  };

  #
  # Config types: relabling
  #

  promTypes.relabel_config = types.submodule {
    options = {
      source_labels = mkOpt (types.listOf types.str) ''
        The source labels select values from existing labels. Their content
        is concatenated using the configured separator and matched against
        the configured regular expression.
      '';

      separator = mkDefOpt types.str ";" ''
        Separator placed between concatenated source label values.
      '';

      target_label = mkOpt types.str ''
        Label to which the resulting value is written in a replace action.
        It is mandatory for replace actions.
      '';

      regex = mkDefOpt types.str "(.*)" ''
        Regular expression against which the extracted value is matched.
      '';

      modulus = mkOpt types.int ''
        Modulus to take of the hash of the source label values.
      '';

      replacement = mkDefOpt types.str "$1" ''
        Replacement value against which a regex replace is performed if the
        regular expression matches.
      '';

      action =
        mkDefOpt (types.enum [ "replace" "lowercase" "uppercase" "keep" "drop" "hashmod" "labelmap" "labeldrop" "labelkeep" ]) "replace" ''
          Action to perform based on regex matching.
        '';
    };
  };

  #
  # Config types : remote read / write
  #

  promTypes.remote_write = types.submodule {
    options = {
      url = mkOption {
        type = types.str;
        description = ''
          ServerName extension to indicate the name of the server.
          http://tools.ietf.org/html/rfc4366#section-3.1
        '';
      };
      remote_timeout = mkOpt types.str ''
        Timeout for requests to the remote write endpoint.
      '';
      headers = mkOpt (types.attrsOf types.str) ''
        Custom HTTP headers to be sent along with each remote write request.
        Be aware that headers that are set by Prometheus itself can't be overwritten.
      '';
      write_relabel_configs = mkOpt (types.listOf promTypes.relabel_config) ''
        List of remote write relabel configurations.
      '';
      name = mkOpt types.str ''
        Name of the remote write config, which if specified must be unique among remote write configs.
        The name will be used in metrics and logging in place of a generated value to help users distinguish between
        remote write configs.
      '';
      basic_auth = mkOpt promTypes.basic_auth ''
        Sets the `Authorization` header on every remote write request with the
        configured username and password.
        password and password_file are mutually exclusive.
      '';
      bearer_token = mkOpt types.str ''
        Sets the `Authorization` header on every remote write request with
        the configured bearer token. It is mutually exclusive with `bearer_token_file`.
      '';
      bearer_token_file = mkOpt types.str ''
        Sets the `Authorization` header on every remote write request with the bearer token
        read from the configured file. It is mutually exclusive with `bearer_token`.
      '';
      sigv4 = mkOpt promTypes.sigv4 ''
        Configures AWS Signature Version 4 settings.
      '';
      tls_config = mkOpt promTypes.tls_config ''
        Configures the remote write request's TLS settings.
      '';
      proxy_url = mkOpt types.str "Optional Proxy URL.";
      queue_config = mkOpt
        (types.submodule {
          options = {
            capacity = mkOpt types.int ''
              Number of samples to buffer per shard before we block reading of more
              samples from the WAL. It is recommended to have enough capacity in each
              shard to buffer several requests to keep throughput up while processing
              occasional slow remote requests.
            '';
            max_shards = mkOpt types.int ''
              Maximum number of shards, i.e. amount of concurrency.
            '';
            min_shards = mkOpt types.int ''
              Minimum number of shards, i.e. amount of concurrency.
            '';
            max_samples_per_send = mkOpt types.int ''
              Maximum number of samples per send.
            '';
            batch_send_deadline = mkOpt types.str ''
              Maximum time a sample will wait in buffer.
            '';
            min_backoff = mkOpt types.str ''
              Initial retry delay. Gets doubled for every retry.
            '';
            max_backoff = mkOpt types.str ''
              Maximum retry delay.
            '';
          };
        }) ''
        Configures the queue used to write to remote storage.
      '';
      metadata_config = mkOpt
        (types.submodule {
          options = {
            send = mkOpt types.bool ''
              Whether metric metadata is sent to remote storage or not.
            '';
            send_interval = mkOpt types.str ''
              How frequently metric metadata is sent to remote storage.
            '';
          };
        }) ''
        Configures the sending of series metadata to remote storage.
        Metadata configuration is subject to change at any point
        or be removed in future releases.
      '';
    };
  };

  promTypes.remote_read = types.submodule {
    options = {
      url = mkOption {
        type = types.str;
        description = ''
          ServerName extension to indicate the name of the server.
          http://tools.ietf.org/html/rfc4366#section-3.1
        '';
      };
      name = mkOpt types.str ''
        Name of the remote read config, which if specified must be unique among remote read configs.
        The name will be used in metrics and logging in place of a generated value to help users distinguish between
        remote read configs.
      '';
      required_matchers = mkOpt (types.attrsOf types.str) ''
        An optional list of equality matchers which have to be
        present in a selector to query the remote read endpoint.
      '';
      remote_timeout = mkOpt types.str ''
        Timeout for requests to the remote read endpoint.
      '';
      headers = mkOpt (types.attrsOf types.str) ''
        Custom HTTP headers to be sent along with each remote read request.
        Be aware that headers that are set by Prometheus itself can't be overwritten.
      '';
      read_recent = mkOpt types.bool ''
        Whether reads should be made for queries for time ranges that
        the local storage should have complete data for.
      '';
      basic_auth = mkOpt promTypes.basic_auth ''
        Sets the `Authorization` header on every remote read request with the
        configured username and password.
        password and password_file are mutually exclusive.
      '';
      bearer_token = mkOpt types.str ''
        Sets the `Authorization` header on every remote read request with
        the configured bearer token. It is mutually exclusive with `bearer_token_file`.
      '';
      bearer_token_file = mkOpt types.str ''
        Sets the `Authorization` header on every remote read request with the bearer token
        read from the configured file. It is mutually exclusive with `bearer_token`.
      '';
      tls_config = mkOpt promTypes.tls_config ''
        Configures the remote read request's TLS settings.
      '';
      proxy_url = mkOpt types.str "Optional Proxy URL.";
    };
  };

in
{

  imports = [
    (mkRenamedOptionModule [ "services" "prometheus2" ] [ "services" "prometheus" ])
    (mkRemovedOptionModule [ "services" "prometheus" "environmentFile" ]
      "It has been removed since it was causing issues (https://github.com/NixOS/nixpkgs/issues/126083) and Prometheus now has native support for secret files, i.e. `basic_auth.password_file` and `authorization.credentials_file`.")
    (mkRemovedOptionModule [ "services" "prometheus" "alertmanagerTimeout" ]
      "Deprecated upstream and no longer had any effect")
  ];

  options.services.prometheus = {

    enable = mkEnableOption "Prometheus monitoring daemon";

    package = mkPackageOption pkgs "prometheus" { };

    port = mkOption {
      type = types.port;
      default = 9090;
      description = ''
        Port to listen on.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = ''
        Address to listen on for the web interface, API, and telemetry.
      '';
    };

    stateDir = mkOption {
      type = types.str;
      default = "prometheus2";
      description = ''
        Directory below `/var/lib` to store Prometheus metrics data.
        This directory will be created automatically using systemd's StateDirectory mechanism.
      '';
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra commandline options when launching Prometheus.
      '';
    };

    enableReload = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Reload prometheus when configuration file changes (instead of restart).

        The following property holds: switching to a configuration
        (`switch-to-configuration`) that changes the prometheus
        configuration only finishes successfully when prometheus has finished
        loading the new configuration.
      '';
    };

    enableAgentMode = mkEnableOption "agent mode";

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
      default = { };
      description = ''
        Parameters that are valid in all  configuration contexts. They
        also serve as defaults for other configuration sections
      '';
    };

    remoteRead = mkOption {
      type = types.listOf promTypes.remote_read;
      default = [ ];
      description = ''
        Parameters of the endpoints to query from.
        See [the official documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_read) for more information.
      '';
    };

    remoteWrite = mkOption {
      type = types.listOf promTypes.remote_write;
      default = [ ];
      description = ''
        Parameters of the endpoints to send samples to.
        See [the official documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write) for more information.
      '';
    };

    rules = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Alerting and/or Recording rules to evaluate at runtime.
      '';
    };

    ruleFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        Any additional rules files to include in this configuration.
      '';
    };

    scrapeConfigs = mkOption {
      type = types.listOf promTypes.scrape_config;
      default = [ ];
      description = ''
        A list of scrape configurations.
      '';
    };

    alertmanagers = mkOption {
      type = types.listOf types.attrs;
      example = literalExpression ''
        [ {
          scheme = "https";
          path_prefix = "/alertmanager";
          static_configs = [ {
            targets = [
              "prometheus.domain.tld"
            ];
          } ];
        } ]
      '';
      default = [ ];
      description = ''
        A list of alertmanagers to send alerts to.
        See [the official documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#alertmanager_config) for more information.
      '';
    };

    alertmanagerNotificationQueueCapacity = mkOption {
      type = types.int;
      default = 10000;
      description = ''
        The capacity of the queue for pending alert manager notifications.
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

    webConfigFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Specifies which file should be used as web.config.file and be passed on startup.
        See https://prometheus.io/docs/prometheus/latest/configuration/https/ for valid options.
      '';
    };

    checkConfig = mkOption {
      type = with types; either bool (enum [ "syntax-only" ]);
      default = true;
      example = "syntax-only";
      description = ''
        Check configuration with `promtool check`. The call to `promtool` is
        subject to sandboxing by Nix.

        If you use credentials stored in external files
        (`password_file`, `bearer_token_file`, etc),
        they will not be visible to `promtool`
        and it will report errors, despite a correct configuration.
        To resolve this, you may set this option to `"syntax-only"`
        in order to only syntax check the Prometheus configuration.
      '';
    };

    retentionTime = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "15d";
      description = ''
        How long to retain samples in storage.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (
        let
          # Match something with dots (an IPv4 address) or something ending in
          # a square bracket (an IPv6 addresses) followed by a port number.
          legacy = builtins.match "(.*\\..*|.*]):([[:digit:]]+)" cfg.listenAddress;
        in
        {
          assertion = legacy == null;
          message = ''
            Do not specify the port for Prometheus to listen on in the
            listenAddress option; use the port option instead:
              services.prometheus.listenAddress = ${builtins.elemAt legacy 0};
              services.prometheus.port = ${builtins.elemAt legacy 1};
          '';
        }
      )
    ];

    users.groups.prometheus.gid = config.ids.gids.prometheus;
    users.users.prometheus = {
      description = "Prometheus daemon user";
      uid = config.ids.uids.prometheus;
      group = "prometheus";
    };
    environment.etc."prometheus/prometheus.yaml" = mkIf cfg.enableReload {
      source = prometheusYml;
    };
    systemd.services.prometheus = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/prometheus" +
          optionalString (length cmdlineArgs != 0) (" \\\n  " +
            concatStringsSep " \\\n  " cmdlineArgs);
        ExecReload = mkIf cfg.enableReload "+${reload}/bin/reload-prometheus";
        User = "prometheus";
        Restart = "always";
        RuntimeDirectory = "prometheus";
        RuntimeDirectoryMode = "0700";
        WorkingDirectory = workingDir;
        StateDirectory = cfg.stateDir;
        StateDirectoryMode = "0700";
        # Hardening
        DeviceAllow = [ "/dev/null rw" ];
        DevicePolicy = "strict";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged" ];
      };
    };
    # prometheus-config-reload will activate after prometheus. However, what we
    # don't want is that on startup it immediately reloads prometheus because
    # prometheus itself might have just started.
    #
    # Instead we only want to reload prometheus when the config file has
    # changed. So on startup prometheus-config-reload will just output a
    # harmless message and then stay active (RemainAfterExit).
    #
    # Then, when the config file has changed, switch-to-configuration notices
    # that this service has changed (restartTriggers) and needs to be reloaded
    # (reloadIfChanged). The reload command then reloads prometheus.
    systemd.services.prometheus-config-reload = mkIf cfg.enableReload {
      wantedBy = [ "prometheus.service" ];
      after = [ "prometheus.service" ];
      reloadIfChanged = true;
      restartTriggers = [ prometheusYml ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        TimeoutSec = 60;
        ExecStart = "${pkgs.logger}/bin/logger 'prometheus-config-reload will only reload prometheus when reloaded itself.'";
        ExecReload = [ "${triggerReload}/bin/trigger-reload-prometheus" ];
      };
    };
  };
}
