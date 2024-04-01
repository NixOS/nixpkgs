{ config, options, pkgs, lib, ... }:
let
  inherit (lib) literalExpression mkOption mkEnableOption mkIf mkMerge types optional;

  cfg = config.services.uptime;
  opt = options.services.uptime;

  configDir = pkgs.runCommand "config" { preferLocalBuild = true; }
  (if cfg.configFile != null then ''
    mkdir $out
    ext=`echo ${cfg.configFile} | grep -o \\..*`
    ln -sv ${cfg.configFile} $out/default$ext
    ln -sv /var/lib/uptime/runtime.json $out/runtime.json
  '' else ''
    mkdir $out
    cat ${pkgs.nodePackages.node-uptime}/lib/node_modules/node-uptime/config/default.yaml > $out/default.yaml
    cat >> $out/default.yaml <<EOF

    autoStartMonitor: false

    mongodb:
      connectionString: 'mongodb://localhost/uptime'
    EOF
    ln -sv /var/lib/uptime/runtime.json $out/runtime.json
  '');
in {
  options.services.uptime = {
    configFile = mkOption {
      description = lib.mdDoc ''
        The uptime configuration file

        If mongodb: server != localhost, please set usesRemoteMongo = true

        If you only want to run the monitor, please set enableWebService = false
        and enableSeparateMonitoringService = true

        If autoStartMonitor: false (recommended) and you want to run both
        services, please set enableSeparateMonitoringService = true
      '';

      type = types.nullOr types.path;

      default = null;
    };

    usesRemoteMongo = mkOption {
      description = lib.mdDoc "Whether the configuration file specifies a remote mongo instance";

      default = false;

      type = types.bool;
    };

    enableWebService = mkEnableOption "the uptime monitoring program web service";

    enableSeparateMonitoringService = mkEnableOption "the uptime monitoring service" // {
      default = cfg.enableWebService;
      defaultText = literalExpression "config.${opt.enableWebService}";
    };

    nodeEnv = mkOption {
      description = lib.mdDoc "The node environment to run in (development, production, etc.)";

      type = types.str;

      default = "production";
    };
  };

  config = mkMerge [ (mkIf cfg.enableWebService {
    systemd.services.uptime = {
      description = "uptime web service";
      wantedBy = [ "multi-user.target" ];
      environment = {
        NODE_CONFIG_DIR = configDir;
        NODE_ENV = cfg.nodeEnv;
        NODE_PATH = "${pkgs.nodePackages.node-uptime}/lib/node_modules/node-uptime/node_modules";
      };
      preStart = "mkdir -p /var/lib/uptime";
      serviceConfig.ExecStart = "${pkgs.nodejs}/bin/node ${pkgs.nodePackages.node-uptime}/lib/node_modules/node-uptime/app.js";
    };

    services.mongodb.enable = mkIf (!cfg.usesRemoteMongo) true;
  }) (mkIf cfg.enableSeparateMonitoringService {
    systemd.services.uptime-monitor = {
      description = "uptime monitoring service";
      wantedBy = [ "multi-user.target" ];
      requires = optional cfg.enableWebService "uptime.service";
      after = optional cfg.enableWebService "uptime.service";
      environment = {
        NODE_CONFIG_DIR = configDir;
        NODE_ENV = cfg.nodeEnv;
        NODE_PATH = "${pkgs.nodePackages.node-uptime}/lib/node_modules/node-uptime/node_modules";
      };
      # Ugh, need to wait for web service to be up
      preStart = if cfg.enableWebService then "sleep 1s" else "mkdir -p /var/lib/uptime";
      serviceConfig.ExecStart = "${pkgs.nodejs}/bin/node ${pkgs.nodePackages.node-uptime}/lib/node_modules/node-uptime/monitor.js";
    };
  }) ];
}
