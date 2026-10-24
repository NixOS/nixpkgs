{
  config,
  lib,
  utils,
  pkgs,
  ...
}:

let
  inherit (lib)
    attrValues
    literalExpression
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    types
    ;

  cfg = config.services.filebeat;

  json = pkgs.formats.json { };
in
{
  meta.maintainers = with lib.maintainers; [ felbinger ];
  options = {

    services.filebeat = {

      enable = mkEnableOption "filebeat";

      package = mkPackageOption pkgs "filebeat" { example = "filebeat7"; };

      inputs = mkOption {
        description = ''
          Inputs specify how Filebeat locates and processes input data.

          This is like `services.filebeat.settings.filebeat.inputs`,
          but structured as an attribute set. This has the benefit
          that multiple NixOS modules can contribute settings to a
          single filebeat input.

          An input type can be specified multiple times by choosing a
          different `<name>` for each, but setting
          [](#opt-services.filebeat.inputs._name_.type)
          to the same value.

          See <https://www.elastic.co/guide/en/beats/filebeat/current/configuration-filebeat-options.html>.
        '';
        default = { };
        type = types.attrsOf (
          types.submodule (
            { name, ... }:
            {
              freeformType = json.type;
              options = {
                type = mkOption {
                  type = types.str;
                  default = name;
                  description = ''
                    The input type.

                    Look for the value after `type:` on
                    the individual input pages linked from
                    <https://www.elastic.co/guide/en/beats/filebeat/current/configuration-filebeat-options.html>.
                  '';
                };
              };
            }
          )
        );
        example = literalExpression ''
          {
            journald.id = "everything";  # Only for filebeat7
            log = {
              enabled = true;
              paths = [
                "/var/log/*.log"
              ];
            };
          };
        '';
      };

      modules = mkOption {
        description = ''
          Filebeat modules provide a quick way to get started
          processing common log formats. They contain default
          configurations, Elasticsearch ingest pipeline definitions,
          and Kibana dashboards to help you implement and deploy a log
          monitoring solution.

          This is like `services.filebeat.settings.filebeat.modules`,
          but structured as an attribute set. This has the benefit
          that multiple NixOS modules can contribute settings to a
          single filebeat module.

          A module can be specified multiple times by choosing a
          different `<name>` for each, but setting
          [](#opt-services.filebeat.modules._name_.module)
          to the same value.

          See <https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-modules.html>.
        '';
        default = { };
        type = types.attrsOf (
          types.submodule (
            { name, ... }:
            {
              freeformType = json.type;
              options = {
                module = mkOption {
                  type = types.str;
                  default = name;
                  description = ''
                    The name of the module.

                    Look for the value after `module:` on
                    the individual input pages linked from
                    <https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-modules.html>.
                  '';
                };
              };
            }
          )
        );
        example = literalExpression ''
          {
            nginx = {
              access = {
                enabled = true;
                var.paths = [ "/path/to/log/nginx/access.log*" ];
              };
              error = {
                enabled = true;
                var.paths = [ "/path/to/log/nginx/error.log*" ];
              };
            };
          };
        '';
      };

      settings = mkOption {
        type = types.submodule {
          freeformType = json.type;

          options = {
            output = mkOption {
              type = types.nullOr (
                types.attrsOf (
                  types.submodule {
                    freeformType = json.type;
                    options = {
                      enabled = mkEnableOption "<name>";
                      hosts = mkOption {
                        type = with types; listOf str;
                        default = [ ];
                        description = ''
                          The list of Elasticsearch/Logstash/Kafka/Redis nodes to connect to.
                          The events are distributed to these nodes in round robin order. If
                          one node becomes unreachable, the event is automatically sent to
                          another node. Each node can be defined as a URL or IP:PORT.
                        '';
                      };
                    };
                  }
                )
              );
              default = {
                elasticsearch = {
                  enable = true;
                  hosts = [ "127.0.0.1:9200" ];
                };
              };
              example = {
                elasticsearch.enable = false;
                logstash = {
                  enable = true;
                  hosts = [ "myEShost:9200" ];
                };
              };
              description = ''
                You configure Filebeat to write to a specific output by setting options in the
                Outputs section of the `filebeat.yml` config file. Only a single output may be defined.

                The following topics describe how to configure each supported output. If you've secured
                the Elastic Stack, also read Secure for more about security-related configuration options.

                For more information about the available outputs see
                [elastic.co/guide/en/beats/filebeat/current/configuring-output.html](https://www.elastic.co/guide/en/beats/filebeat/current/configuring-output.html).
              '';
            };

            filebeat = {
              inputs = mkOption {
                type = types.listOf json.type;
                default = [ ];
                internal = true;
                description = ''
                  Inputs specify how Filebeat locates and processes
                  input data. Use [](#opt-services.filebeat.inputs) instead.

                  See <https://www.elastic.co/guide/en/beats/filebeat/current/configuration-filebeat-options.html>.
                '';
              };
              modules = mkOption {
                type = types.listOf json.type;
                default = [ ];
                internal = true;
                description = ''
                  Filebeat modules provide a quick way to get started
                  processing common log formats. They contain default
                  configurations, Elasticsearch ingest pipeline
                  definitions, and Kibana dashboards to help you
                  implement and deploy a log monitoring solution.

                  Use [](#opt-services.filebeat.modules) instead.

                  See <https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-modules.html>.
                '';
              };
            };
          };
        };
        default = { };
        example = literalExpression ''
          {
            settings = {
              output.elasticsearch = {
                hosts = [ "myEShost:9200" ];
                username = "filebeat_internal";
                password = { _secret = "/var/keys/elasticsearch_password"; };
              };
              logging.level = "info";
            };
          };
        '';

        description = ''
          Configuration for filebeat. See
          <https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-reference-yml.html>
          for supported values.

          Options containing secret data should be set to an attribute
          set containing the attribute `_secret` - a
          string pointing to a file containing the value the option
          should be set to. See the example to get a better picture of
          this: in the resulting
          {file}`filebeat.yml` file, the
          `output.elasticsearch.password`
          key will be set to the contents of the
          {file}`/var/keys/elasticsearch_password` file.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    assertions =
      let
        validOutputs = [
          "elasticsearch"
          "logstash"
          "kafka"
          "redis"
          "file"
          "console"
          "discard"
        ];
        validOutputsHosts = [
          "elasticsearch"
          "logstash"
          "kafka"
          "redis"
        ];

        filterEnabled = attrset:
          let
            enabledNames = builtins.filter (name: attrset.${name}.enabled) (builtins.attrNames attrset);
          in
            builtins.listToAttrs (map (name: { name = name; value = attrset.${name}; }) enabledNames);

        enabledOutputs = filterEnabled cfg.settings.output;
      in
      [
        {
          assertion = builtins.length (builtins.attrNames enabledOutputs) == 1;
          message = "only one services.filebeat.settings.output can be configured";
        }
        {
          assertion =
            (builtins.length (builtins.attrNames enabledOutputs) != 1)
            || (builtins.elem (builtins.head (builtins.attrNames enabledOutputs)) validOutputs);
          message = "services.filebeat.settings.output is invalid, choose one of: ${lib.concatStringsSep ", " validOutputs}";
        }
        {
          assertion =
            (builtins.length (builtins.attrNames enabledOutputs) != 1)
            || (builtins.elem (builtins.head (builtins.attrNames enabledOutputs)) validOutputsHosts);
          message = "services.filebeat.settings.output.<name>.hosts can only be configured for: ${lib.concatStringsSep ", " validOutputsHosts}";
        }
      ];

    services.filebeat.settings.filebeat.inputs = attrValues cfg.inputs;
    services.filebeat.settings.filebeat.modules = attrValues cfg.modules;

    systemd.services.filebeat = {
      description = "Filebeat log shipper";
      wantedBy = [ "multi-user.target" ];
      wants = [ "elasticsearch.service" ];
      after = [ "elasticsearch.service" ];
      serviceConfig = {
        ExecStartPre = pkgs.writeShellScript "filebeat-exec-pre" ''
          set -euo pipefail

          umask u=rwx,g=,o=

          ${utils.genJqSecretsReplacementSnippet cfg.settings "/var/lib/filebeat/filebeat.yml"}
        '';
        ExecStart = ''
          ${cfg.package}/bin/filebeat -e \
            -c "/var/lib/filebeat/filebeat.yml" \
            --path.data "/var/lib/filebeat"
        '';
        Restart = "always";
        StateDirectory = "filebeat";
      };
    };
  };
}
