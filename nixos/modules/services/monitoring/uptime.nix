{
  config,
  options,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    literalExpression
    lib.mkOption
    mkEnableOption
    mkIf
    mkMerge
    types
    lib.optional
    ;

  cfg = config.services.uptime;
  opt = options.services.uptime;

  configDir = pkgs.runCommand "config" { preferLocalBuild = true; } (
    if cfg.configFile != null then
      ''
        mkdir $out
        ext=`echo ${cfg.configFile} | grep -o \\..*`
        ln -sv ${cfg.configFile} $out/default$ext
        ln -sv /var/lib/uptime/runtime.json $out/runtime.json
      ''
    else
      ''
        mkdir $out
        cat ${pkgs.nodePackages.node-uptime}/lib/node_modules/node-uptime/config/default.yaml > $out/default.yaml
        cat >> $out/default.yaml <<EOF

        autoStartMonitor: false

        mongodb:
          connectionString: 'mongodb://localhost/uptime'
        EOF
        ln -sv /var/lib/uptime/runtime.json $out/runtime.json
      ''
  );
in
{
  options.services.uptime = {
    configFile = lib.mkOption {
      description = ''
        The uptime configuration file

        If mongodb: server != localhost, please set usesRemoteMongo = true

        If you only want to run the monitor, please set enableWebService = false
        and enableSeparateMonitoringService = true

        If autoStartMonitor: false (recommended) and you want to run both
        services, please set enableSeparateMonitoringService = true
      '';

      type = lib.types.nullOr lib.types.path;

      default = null;
    };

    usesRemoteMongo = lib.mkOption {
      description = "Whether the configuration file specifies a remote mongo instance";

      default = false;

      type = lib.types.bool;
    };

    enableWebService = mkEnableOption "the uptime monitoring program web service";

    enableSeparateMonitoringService = mkEnableOption "the uptime monitoring service" // {
      default = cfg.enableWebService;
      defaultText = lib.literalExpression "config.${opt.enableWebService}";
    };

    nodeEnv = lib.mkOption {
      description = "The node environment to run in (development, production, etc.)";

      type = lib.types.str;

      default = "production";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enableWebService {
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

      services.mongodb.enable = lib.mkIf (!cfg.usesRemoteMongo) true;
    })
    (lib.mkIf cfg.enableSeparateMonitoringService {
      systemd.services.uptime-monitor = {
        description = "uptime monitoring service";
        wantedBy = [ "multi-user.target" ];
        requires = lib.optional cfg.enableWebService "uptime.service";
        after = lib.optional cfg.enableWebService "uptime.service";
        environment = {
          NODE_CONFIG_DIR = configDir;
          NODE_ENV = cfg.nodeEnv;
          NODE_PATH = "${pkgs.nodePackages.node-uptime}/lib/node_modules/node-uptime/node_modules";
        };
        # Ugh, need to wait for web service to be up
        preStart = if cfg.enableWebService then "sleep 1s" else "mkdir -p /var/lib/uptime";
        serviceConfig.ExecStart = "${pkgs.nodejs}/bin/node ${pkgs.nodePackages.node-uptime}/lib/node_modules/node-uptime/monitor.js";
      };
    })
  ];
}
