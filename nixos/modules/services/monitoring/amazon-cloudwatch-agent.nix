{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.amazon-cloudwatch-agent;

  tomlFormat = pkgs.formats.toml { };
  jsonFormat = pkgs.formats.json { };

  commonConfigurationFile = tomlFormat.generate "common-config.toml" cfg.commonConfiguration;
  configurationFile = jsonFormat.generate "amazon-cloudwatch-agent.json" cfg.configuration;
  # See https://docs.aws.amazon.com/prescriptive-guidance/latest/implementing-logging-monitoring-cloudwatch/create-store-cloudwatch-configurations.html#store-cloudwatch-configuration-s3.
  #
  # We don't use the multiple JSON configuration files feature,
  # but "config-translator" will log a benign error if the "-input-dir" option is omitted or is a non-existent directory.
  #
  # Create an empty directory to hide this benign error log. This prevents false-positives if users filter for "error" in the agent logs.
  configurationDirectory = pkgs.runCommand "amazon-cloudwatch-agent.d" { } "mkdir $out";
in
{
  options.services.amazon-cloudwatch-agent = {
    enable = lib.mkEnableOption "Amazon CloudWatch Agent";
    package = lib.mkPackageOption pkgs "amazon-cloudwatch-agent" { };
    commonConfiguration = lib.mkOption {
      type = tomlFormat.type;
      default = { };
      description = ''
        Amazon CloudWatch Agent common configuration. See
        <https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/install-CloudWatch-Agent-commandline-fleet.html#CloudWatch-Agent-profile-instance-first>
        for supported values.
      '';
      example = {
        credentials = {
          shared_credential_profile = "profile_name";
          shared_credential_file = "/path/to/credentials";
        };
        proxy = {
          http_proxy = "http_url";
          https_proxy = "https_url";
          no_proxy = "domain";
        };
      };
    };
    configuration = lib.mkOption {
      type = jsonFormat.type;
      default = { };
      description = ''
        Amazon CloudWatch Agent configuration. See
        <https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html>
        for supported values.
      '';
      # Subset of "CloudWatch agent configuration file: Complete examples" and "CloudWatch agent configuration file: Traces section" in the description link.
      #
      # Log file path changed from "/opt/aws/amazon-cloudwatch-agent/logs" to "/var/log/amazon-cloudwatch-agent" to follow the FHS.
      example = {
        agent = {
          metrics_collection_interval = 10;
          logfile = "/var/log/amazon-cloudwatch-agent/amazon-cloudwatch-agent.log";
        };
        metrics = {
          namespace = "MyCustomNamespace";
          metrics_collected = {
            cpu = {
              resource = [ "*" ];
              measurement = [
                {
                  name = "cpu_usage_idle";
                  rename = "CPU_USAGE_IDLE";
                  unit = "Percent";
                }
                {
                  name = "cpu_usage_nice";
                  unit = "Percent";
                }
                "cpu_usage_guest"
              ];
              totalcpu = false;
              metrics_collection_interval = 10;
              append_dimensions = {
                customized_dimension_key_1 = "customized_dimension_value_1";
                customized_dimension_key_2 = "customized_dimension_value_2";
              };
            };
          };
        };
        logs = {
          logs_collected = {
            files = {
              collect_list = [
                {
                  file_path = "/var/log/amazon-cloudwatch-agent/amazon-cloudwatch-agent.log";
                  log_group_name = "amazon-cloudwatch-agent.log";
                  log_stream_name = "{instance_id}";
                  timezone = "UTC";
                }
              ];
            };
          };
          log_stream_name = "log_stream_name";
          force_flush_interval = 15;
        };
        traces = {
          traces_collected = {
            xray = { };
            oltp = { };
          };
        };
      };
    };
    mode = lib.mkOption {
      type = lib.types.str;
      default = "auto";
      description = ''
        Amazon CloudWatch Agent mode. Indicates whether the agent is running in EC2 ("ec2"), on-premises ("onPremise"),
        or if it should guess based on metadata endpoints like IMDS or the ECS task metadata endpoint ("auto").
      '';
      example = "onPremise";
    };
  };

  config = lib.mkIf cfg.enable {
    # See https://github.com/aws/amazon-cloudwatch-agent/blob/v1.300048.1/packaging/dependencies/amazon-cloudwatch-agent.service.
    systemd.services.amazon-cloudwatch-agent = {
      description = "Amazon CloudWatch Agent";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        # "start-amazon-cloudwatch-agent" assumes the package is installed at "/opt/aws/amazon-cloudwatch-agent" so we can't use it.
        #
        # See https://github.com/aws/amazon-cloudwatch-agent/issues/1319.
        #
        # This program:
        # 1. Switches to a non-root user if configured.
        # 2. Runs "config-translator" to translate the input JSON configuration files into separate TOML (for CloudWatch Logs + Metrics),
        #    YAML (for X-Ray + OpenTelemetry), and JSON (for environment variables) configuration files.
        # 3. Runs "amazon-cloudwatch-agent" with the paths to these generated files.
        #
        # Re-implementing with systemd options.
        User = lib.attrByPath [
          "agent"
          "run_as_user"
        ] "root" cfg.configuration;
        RuntimeDirectory = "amazon-cloudwatch-agent";
        LogsDirectory = "amazon-cloudwatch-agent";
        ExecStartPre = ''
          ${cfg.package}/bin/config-translator \
            -config ${commonConfigurationFile} \
            -input ${configurationFile} \
            -input-dir ${configurationDirectory} \
            -mode ${cfg.mode} \
            -output ''${RUNTIME_DIRECTORY}/amazon-cloudwatch-agent.toml
        '';
        ExecStart = ''
          ${cfg.package}/bin/amazon-cloudwatch-agent \
            -config ''${RUNTIME_DIRECTORY}/amazon-cloudwatch-agent.toml \
            -envconfig ''${RUNTIME_DIRECTORY}/env-config.json \
            -otelconfig ''${RUNTIME_DIRECTORY}/amazon-cloudwatch-agent.yaml \
            -pidfile ''${RUNTIME_DIRECTORY}/amazon-cloudwatch-agent.pid
        '';
        KillMode = "process";
        Restart = "on-failure";
        RestartSec = 60;
      };
      restartTriggers = [
        cfg.package
        commonConfigurationFile
        configurationFile
        configurationDirectory
        cfg.mode
      ];
    };
  };

  meta.maintainers = pkgs.amazon-cloudwatch-agent.meta.maintainers;
}
