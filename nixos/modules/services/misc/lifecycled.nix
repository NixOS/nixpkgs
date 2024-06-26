{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.services.lifecycled;

  # TODO: Add the ability to extend this with an rfc 42-like interface.
  # In the meantime, one can modify the environment (as
  # long as it's not overriding anything from here) with
  # systemd.services.lifecycled.serviceConfig.Environment
  configFile = pkgs.writeText "lifecycled" ''
    LIFECYCLED_HANDLER=${cfg.handler}
    ${lib.optionalString (
      cfg.cloudwatchGroup != null
    ) "LIFECYCLED_CLOUDWATCH_GROUP=${cfg.cloudwatchGroup}"}
    ${lib.optionalString (
      cfg.cloudwatchStream != null
    ) "LIFECYCLED_CLOUDWATCH_STREAM=${cfg.cloudwatchStream}"}
    ${lib.optionalString cfg.debug "LIFECYCLED_DEBUG=${lib.boolToString cfg.debug}"}
    ${lib.optionalString (cfg.instanceId != null) "LIFECYCLED_INSTANCE_ID=${cfg.instanceId}"}
    ${lib.optionalString cfg.json "LIFECYCLED_JSON=${lib.boolToString cfg.json}"}
    ${lib.optionalString cfg.noSpot "LIFECYCLED_NO_SPOT=${lib.boolToString cfg.noSpot}"}
    ${lib.optionalString (cfg.snsTopic != null) "LIFECYCLED_SNS_TOPIC=${cfg.snsTopic}"}
    ${lib.optionalString (cfg.awsRegion != null) "AWS_REGION=${cfg.awsRegion}"}
  '';
in
{
  meta.maintainers = with maintainers; [
    cole-h
    grahamc
  ];

  options = {
    services.lifecycled = {
      enable = mkEnableOption "lifecycled, a daemon for responding to AWS AutoScaling Lifecycle Hooks";

      queueCleaner = {
        enable = mkEnableOption "lifecycled-queue-cleaner";

        frequency = mkOption {
          type = types.str;
          default = "hourly";
          description = ''
            How often to trigger the queue cleaner.

            NOTE: This string should be a valid value for a systemd
            timer's `OnCalendar` configuration. See
            {manpage}`systemd.timer(5)`
            for more information.
          '';
        };

        parallel = mkOption {
          type = types.ints.unsigned;
          default = 20;
          description = ''
            The number of parallel deletes to run.
          '';
        };
      };

      instanceId = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The instance ID to listen for events for.
        '';
      };

      snsTopic = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The SNS topic that receives events.
        '';
      };

      noSpot = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Disable the spot termination listener.
        '';
      };

      handler = mkOption {
        type = types.path;
        description = ''
          The script to invoke to handle events.
        '';
      };

      json = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable JSON logging.
        '';
      };

      cloudwatchGroup = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Write logs to a specific Cloudwatch Logs group.
        '';
      };

      cloudwatchStream = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Write logs to a specific Cloudwatch Logs stream. Defaults to the instance ID.
        '';
      };

      debug = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable debugging information.
        '';
      };

      # XXX: Can be removed if / when
      # https://github.com/buildkite/lifecycled/pull/91 is merged.
      awsRegion = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The region used for accessing AWS services.
        '';
      };
    };
  };

  ### Implementation ###

  config = mkMerge [
    (mkIf cfg.enable {
      environment.etc."lifecycled".source = configFile;

      systemd.packages = [ pkgs.lifecycled ];
      systemd.services.lifecycled = {
        wantedBy = [ "network-online.target" ];
        restartTriggers = [ configFile ];
      };
    })

    (mkIf cfg.queueCleaner.enable {
      systemd.services.lifecycled-queue-cleaner = {
        description = "Lifecycle Daemon Queue Cleaner";
        environment = optionalAttrs (cfg.awsRegion != null) { AWS_REGION = cfg.awsRegion; };
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.lifecycled}/bin/lifecycled-queue-cleaner -parallel ${toString cfg.queueCleaner.parallel}";
        };
      };

      systemd.timers.lifecycled-queue-cleaner = {
        description = "Lifecycle Daemon Queue Cleaner Timer";
        wantedBy = [ "timers.target" ];
        after = [ "network-online.target" ];
        timerConfig = {
          Unit = "lifecycled-queue-cleaner.service";
          OnCalendar = "${cfg.queueCleaner.frequency}";
        };
      };
    })
  ];
}
