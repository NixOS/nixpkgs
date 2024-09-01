{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    attrsets
    mkEnableOption
    mkOption
    optionalAttrs
    types
    ;

  cfg = config.services.amazon-cloudwatch-agent;

  assembledConfig = attrsets.mergeAttrsList [
    (optionalAttrs (cfg.configAgent != null) { agent = cfg.configAgent; })
    (optionalAttrs (cfg.configMetrics != null) { metrics = cfg.configMetrics; })
    (optionalAttrs (cfg.configLogs != null) { logs = cfg.configLogs; })
    (optionalAttrs (cfg.configTraces != null) { traces = cfg.configTraces; })
  ];

  agentConfigFile = (pkgs.formats.json { }).generate "config.json" assembledConfig;

  awsCredsFile = (pkgs.formats.ini { }).generate "aws-credentials" {
    AmazonCloudWatchAgent = cfg.configAwsCreds;
  };

  commonConfigTomlFile = (pkgs.formats.toml { }).generate "common-config.toml" {
    credentials = {
      shared_credential_file = "${awsCredsFile}";
      shared_credential_profile = "AmazonCloudWatchAgent";
    };
  };
in
{
  options = {
    services.amazon-cloudwatch-agent = {
      package = lib.mkPackageOption pkgs "amazon-cloudwatch-agent" { };

      enable = mkEnableOption ''
        Amazon CloudWatch Amazon
      '';

      configAwsCreds = mkOption {
        type = types.submodule {
          freeformType = with types; attrsOf str;
        };
        description = "AWS credentials for CloudWatch Agent (https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/install-CloudWatch-Agent-on-premise.html)";
        default = {
          aws_access_key_id = "FILL-IN";
          aws_secret_access_key = "FILL-IN";
          region = "FILL-IN";
        };
      };

      configAgent = mkOption {
        type = types.submodule {
          freeformType = types.oneOf [
            (pkgs.formats.json { }).type
            null
          ];
        };
        description = "Agent section of the CloudWatch Agent configuration (https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html)";
        default = null;
      };

      configMetrics = mkOption {
        type = types.submodule {
          freeformType = types.oneOf [
            (pkgs.formats.json { }).type
            null
          ];
        };
        description = "Metrics section of the CloudWatch Agent configuration (https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html)";
        default = null;
      };

      configLogs = mkOption {
        type = types.nullOr (
          types.submodule {
            freeformType = (pkgs.formats.json { }).type;
          }
        );
        description = "Logs section of the CloudWatch Agent configuration (https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html)";
        default = null; # not empty object because, if we specify the key, we must also specify certain child attributes.
      };

      configTraces = mkOption {
        type = types.nullOr (
          types.submodule {
            freeformType = (pkgs.formats.json { }).type;
          }
        );
        description = "Traces section of the CloudWatch Agent configuration (https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html)";
        default = null; # not empty object because, if we specify the key, we must also specify certain child attributes.
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ]; # FIXME: what does this do?

    users.users.cwagent = {
      description = "amazon-cloudwatch-agent daemon user";
      isSystemUser = true;
      group = "cwagent";
    };

    users.groups.cwagent = { };

    systemd.tmpfiles.rules = [
      "D /opt/aws/amazon-cloudwatch-agent/etc 750 cwagent cwagent" # for symlinks made by this file, and where the agent wants to write the toml config
      "D /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d 750 cwagent cwagent" # where the agent wants to write to
      "D /opt/aws/amazon-cloudwatch-agent/logs 750 cwagent cwagent"
      "D /opt/aws/amazon-cloudwatch-agent/var 750 cwagent cwagent"
      "L+ /opt/aws/amazon-cloudwatch-agent/etc/common-config.toml - - - - ${commonConfigTomlFile}"
      "L+ /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json - - - - ${agentConfigFile}"
      "L+ /opt/aws/amazon-cloudwatch-agent/bin - - - - ${cfg.package}/bin"
    ];

    systemd.services.amazon-cloudwatch-agent = {
      enable = true;
      description = "Amazon CloudWatch Agent";
      documentation = [
        "https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html"
      ];

      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        # systemd runs the agent as root, then the agent will switch to the dedicated user
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 60;
        ExecStart = "${cfg.package}/bin/start-amazon-cloudwatch-agent";
        KillMode = "process";
        # According to systemd documentation, the simple type does not need this, but we have it anyway, so can't hurt to specify it.
        PIDFile = "/opt/aws/amazon-cloudwatch-agent/var/amazon-cloudwatch-agent.pid";
      };
    };
  };
}
