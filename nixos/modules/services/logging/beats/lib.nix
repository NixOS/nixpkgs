{ lib, pkgs, ... }:

with lib;

{

  mkCommonOptions = { name, defaults }: {

    enable = mkEnableOption "Enable ${name}.";

    package = mkOption {
      description = "${name} package to use.";
      type = types.package;
      default = defaults.package;
    };

    executable = mkOption {
      description = "Name of the executable within <option>package</option> to run.";
      type = types.str;
      default = defaults.executable or name;
    };

    name = mkOption {
      description = "Name of the beat";
      type = types.str;
      default = defaults.name or name;
    };

    tags = mkOption {
      description = "Tags to place on the shipped log messages";
      type = types.listOf types.str;
      default = [];
    };

    stateDir = mkOption {
      description = "The state directory.";
      type = types.str;
      default = defaults.stateDir or "/var/lib/${name}";
    };

    loglevel = mkOption {
      description = "Logging verbosity level.";
      type = types.enum [ "debug" "info" "warning" "error" "fatal" ];
      default = "warning";
    };

    extraConfig = mkOption {
      description = "Additional config to be added to the beats config.json.";
      type = types.attrs;
      default = {};
    };

    elasticsearch = {
      hosts = mkOption {
        description = "Elasticsearch hosts";
        type = with types; listOf str;
        default = [ "localhost:9200" ];
      };

      username = mkOption {
        description = "Username for elasticsearch basic auth.";
        type = types.nullOr types.str;
        default = null;
      };

      password = mkOption {
        description = "Password for elasticsearch basic auth.";
        type = types.nullOr types.str;
        default = null;
      };
    };

    kibana = {
      host = mkOption {
        description = "Host where kibana is reachable.";
        type = types.str;
        default = "localhost:5601";
      };
    };

  };

  mkNixosConfig = { cfg, mkBeatConfig }: let

    mkCommonBeatConfig = cfg: {
      inherit (cfg) tags;

      path = {
        data = "${cfg.stateDir}/data";
        logs = "${cfg.stateDir}/logs";
      };

      logging.level = cfg.loglevel;

      output = { inherit (cfg) elasticsearch; };

      setup.template = {
        fields = "${cfg.package}/share/fields.yml";
        settings.index = {
          number_of_shards = 1;
          codec = "best_compression";
        };
      };

      setup.kibana = {
        inherit (cfg.kibana) host;
      };

      setup.dashboards = {
        enabled = true;
        directory ="${cfg.package}/share/kibana";
      };
    };

    beatConfig = foldl' recursiveUpdate {} [
      (mkCommonBeatConfig cfg)
      (mkBeatConfig cfg)
      cfg.extraConfig
    ];
    beatConfigJSON = pkgs.writeText "${cfg.name}.json" (builtins.toJSON beatConfig);

  in mkIf cfg.enable {

    systemd.services.${cfg.name} = {
      wantedBy = [ "multi-user.target" ];

      after = let
        hasLocalKibana = lib.strings.hasInfix "localhost" cfg.kibana.host;
        hasLocalElasticsearch = (findSingle (x: lib.strings.hasInfix "localhost" x) null "multiple" cfg.elasticsearch.hosts) != null;
      in []
        ++ optional hasLocalKibana "kibana.service"
        ++ optional hasLocalElasticsearch "elasticsearch.service";

      preStart = ''
        mkdir -p ${beatConfig.path.data}
        mkdir -p ${beatConfig.path.logs}
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/${cfg.executable} -c ${beatConfigJSON}";
      };
    };
  };

}
