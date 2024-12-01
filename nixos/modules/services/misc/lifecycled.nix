{ config, pkgs, lib, ... }:
let
  cfg = config.services.lifecycled;

  # TODO: Add the ability to extend this with an rfc 42-like interface.
  # In the meantime, one can modify the environment (as
  # long as it's not overriding anything from here) with
  # systemd.services.lifecycled.serviceConfig.Environment
  configFile = pkgs.writeText "lifecycled" ''
    LIFECYCLED_HANDLER=${cfg.handler}
    ${lib.optionalString (cfg.cloudwatchGroup != null) "LIFECYCLED_CLOUDWATCH_GROUP=${cfg.cloudwatchGroup}"}
    ${lib.optionalString (cfg.cloudwatchStream != null) "LIFECYCLED_CLOUDWATCH_STREAM=${cfg.cloudwatchStream}"}
    ${lib.optionalString cfg.debug "LIFECYCLED_DEBUG=${lib.boolToString cfg.debug}"}
    ${lib.optionalString (cfg.instanceId != null) "LIFECYCLED_INSTANCE_ID=${cfg.instanceId}"}
    ${lib.optionalString cfg.json "LIFECYCLED_JSON=${lib.boolToString cfg.json}"}
    ${lib.optionalString cfg.noSpot "LIFECYCLED_NO_SPOT=${lib.boolToString cfg.noSpot}"}
    ${lib.optionalString (cfg.snsTopic != null) "LIFECYCLED_SNS_TOPIC=${cfg.snsTopic}"}
    ${lib.optionalString (cfg.awsRegion != null) "AWS_REGION=${cfg.awsRegion}"}
  '';
in
{
  meta.maintainers = with lib.maintainers; [ cole-h grahamc ];

  options = {
    services.lifecycled = {
      enable = lib.mkEnableOption "lifecycled, a daemon for responding to AWS AutoScaling Lifecycle Hooks";

      queueCleaner = {
        enable = lib.mkEnableOption "lifecycled-queue-cleaner";

        frequency = lib.mkOption {
          type = lib.types.str;
          default = "hourly";
          description = ''
            How often to trigger the queue cleaner.

            NOTE: This string should be a valid value for a systemd
            timer's `OnCalendar` configuration. See
            {manpage}`systemd.timer(5)`
            for more information.
          '';
        };

        parallel = lib.mkOption {
          type = lib.types.ints.unsigned;
          default = 20;
          description = ''
            The number of parallel deletes to run.
          '';
        };
      };

      instanceId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The instance ID to listen for events for.
        '';
      };

      snsTopic = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The SNS topic that receives events.
        '';
      };

      noSpot = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Disable the spot termination listener.
        '';
      };

      handler = lib.mkOption {
        type = lib.types.path;
        description = ''
          The script to invoke to handle events.
        '';
      };

      json = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable JSON logging.
        '';
      };

      cloudwatchGroup = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Write logs to a specific Cloudwatch Logs group.
        '';
      };

      cloudwatchStream = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Write logs to a specific Cloudwatch Logs stream. Defaults to the instance ID.
        '';
      };

      debug = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable debugging information.
        '';
      };

      # XXX: Can be removed if / when
      # https://github.com/buildkite/lifecycled/pull/91 is merged.
      awsRegion = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The region used for accessing AWS services.
        '';
      };
    };
  };

  ### Implementation ###

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.etc."lifecycled".source = configFile;

      systemd.packages = [ pkgs.lifecycled ];
      systemd.services.lifecycled = {
        wantedBy = [ "network-online.target" ];
        restartTriggers = [ configFile ];
      };
    })

    (lib.mkIf cfg.queueCleaner.enable {
      systemd.services.lifecycled-queue-cleaner = {
        description = "Lifecycle Daemon Queue Cleaner";
        environment = lib.optionalAttrs (cfg.awsRegion != null) { AWS_REGION = cfg.awsRegion; };
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
