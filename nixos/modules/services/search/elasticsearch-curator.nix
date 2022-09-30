{ config, lib, pkgs, ... }:

with lib;

let
    cfg = config.services.elasticsearch-curator;
    curatorConfig = pkgs.writeTextFile {
      name = "config.yaml";
      text = ''
        ---
        # Remember, leave a key empty if there is no value.  None will be a string,
        # not a Python "NoneType"
        client:
          hosts: ${builtins.toJSON cfg.hosts}
          port: ${toString cfg.port}
          url_prefix:
          use_ssl: False
          certificate:
          client_cert:
          client_key:
          ssl_no_validate: False
          http_auth:
          timeout: 30
          master_only: False
        logging:
          loglevel: INFO
          logfile:
          logformat: default
          blacklist: ['elasticsearch', 'urllib3']
        '';
    };
    curatorAction = pkgs.writeTextFile {
      name = "action.yaml";
      text = cfg.actionYAML;
    };
in {

  options.services.elasticsearch-curator = {

    enable = mkEnableOption (lib.mdDoc "elasticsearch curator");
    interval = mkOption {
      description = lib.mdDoc "The frequency to run curator, a systemd.time such as 'hourly'";
      default = "hourly";
      type = types.str;
    };
    hosts = mkOption {
      description = lib.mdDoc "a list of elasticsearch hosts to connect to";
      type = types.listOf types.str;
      default = ["localhost"];
    };
    port = mkOption {
      description = lib.mdDoc "the port that elasticsearch is listening on";
      type = types.int;
      default = 9200;
    };
    actionYAML = mkOption {
      description = lib.mdDoc "curator action.yaml file contents, alternatively use curator-cli which takes a simple action command";
      type = types.lines;
      example = ''
        ---
        actions:
          1:
            action: delete_indices
            description: >-
              Delete indices older than 45 days (based on index name), for logstash-
              prefixed indices. Ignore the error if the filter does not result in an
              actionable list of indices (ignore_empty_list) and exit cleanly.
            options:
              ignore_empty_list: True
              disable_action: False
            filters:
            - filtertype: pattern
              kind: prefix
              value: logstash-
            - filtertype: age
              source: name
              direction: older
              timestring: '%Y.%m.%d'
              unit: days
              unit_count: 45
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.elasticsearch-curator = {
      startAt = cfg.interval;
      serviceConfig = {
        ExecStart =
          "${pkgs.elasticsearch-curator}/bin/curator" +
          " --config ${curatorConfig} ${curatorAction}";
      };
    };
  };
}
