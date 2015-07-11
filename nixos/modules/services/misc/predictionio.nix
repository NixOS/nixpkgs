{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.predictionio;

  homeDir = "/var/lib/predictionio";

  pio-env = pkgs.writeText "pio-env.sh" ''
    #!/bin/sh
    SPARK_HOME=${cfg.sparkDistDir}
    PIO_FS_BASEDIR=${homeDir}/.pio_store
    PIO_FS_ENGINESDIR=$PIO_FS_BASEDIR/engines
    PIO_FS_TMPDIR=$PIO_FS_BASEDIR/tmp
  '';

in

{

  options.services.predictionio = {
    
    enable = mkEnableOption "Enable PredictionIO service.";
  
    sparkDistDir = mkOption {
      default = pkgs.spark + "/lib/" + pkgs.spark.name + "-bin-cdh4/";
      type = types.path;
      description = "Path to the spark distribution bundle.";
    };
    
    metaSource = mkOption {
      type = types.enum [ "postgresql" "mysql" "elasticsearch" ];
      default = "elasticsearch";
      description = "Meta data is used by PredictionIO to store engine training and evaluation information.";
    };

    modelSource = mkOption {
      type = types.enum [ "postgresql" "mysql" "hdfs" "localfs" ];
      default = "hdfs";
      description = "Model data is used by PredictionIO for automatic persistence of trained models.";
    };

    eventSource = mkOption {
      type = types.enum [ "postgresql" "mysql" "hbase" ];
      default = "hbase";
      description = "Event data is used by the Event Server to collect events, and by engines to source data.";
    };

  };

  config = mkdIf cfg.enable {

    users.extraUsers.predictionio = {
      group = config.users.extraGroups.predictionio.name;
      description = "PredictionIO user";
      home = homeDir;
      createHome = true;
      uid = config.ids.uids.predictionio;
    };

    users.extraGroups.predictionio.gid = config.ids.gids.predictionio;
    
    systemd.services.predictionio = let
      uid = toString config.ids.uids.predictionio;
      gid = toString config.ids.gids.predictionio;
    in {
      description = "PredictionIO Machine Learning Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
