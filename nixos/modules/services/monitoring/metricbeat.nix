{ config, lib, pkgs, ... }:

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
  cfg = config.services.metricbeat;

  settingsFormat = pkgs.formats.yaml {};

in
{
  options = {

    services.metricbeat = {

      enable = mkEnableOption (lib.mdDoc "metricbeat");

      package = mkPackageOption pkgs "metricbeat" {
        example = "metricbeat7";
      };

      modules = mkOption {
        description = lib.mdDoc ''
          Metricbeat modules are responsible for reading metrics from the various sources.

          This is like `services.metricbeat.settings.metricbeat.modules`,
          but structured as an attribute set. This has the benefit that multiple
          NixOS modules can contribute settings to a single metricbeat module.

          A module can be specified multiple times by choosing a different `<name>`
          for each, but setting [](#opt-services.metricbeat.modules._name_.module) to the same value.

          See <https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-modules.html>.
        '';
        default = {};
        type = types.attrsOf (types.submodule ({ name, ... }: {
          freeformType = settingsFormat.type;
          options = {
            module = mkOption {
              type = types.str;
              default = name;
              description = lib.mdDoc ''
                The name of the module.

                Look for the value after `module:` on the individual
                module pages linked from <https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-modules.html>.
              '';
            };
          };
        }));
        example = {
          system = {
            metricsets = ["cpu" "load" "memory" "network" "process" "process_summary" "uptime" "socket_summary"];
            enabled = true;
            period = "10s";
            processes = [".*"];
            cpu.metrics = ["percentages" "normalized_percentages"];
            core.metrics = ["percentages"];
          };
        };
      };

      settings = mkOption {
        type = types.submodule {
          freeformType = settingsFormat.type;
          options = {

            name = mkOption {
              type = types.str;
              default = "";
              description = lib.mdDoc ''
                Name of the beat. Defaults to the hostname.
                See <https://www.elastic.co/guide/en/beats/metricbeat/current/configuration-general-options.html#_name>.
              '';
            };

            tags = mkOption {
              type = types.listOf types.str;
              default = [];
              description = lib.mdDoc ''
                Tags to place on the shipped metrics.
                See <https://www.elastic.co/guide/en/beats/metricbeat/current/configuration-general-options.html#_tags_2>.
              '';
            };

            metricbeat.modules = mkOption {
              type = types.listOf settingsFormat.type;
              default = [];
              internal = true;
              description = lib.mdDoc ''
                The metric collecting modules. Use [](#opt-services.metricbeat.modules) instead.

                See <https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-modules.html>.
              '';
            };
          };
        };
        default = {};
        description = lib.mdDoc ''
          Configuration for metricbeat. See <https://www.elastic.co/guide/en/beats/metricbeat/current/configuring-howto-metricbeat.html> for supported values.
        '';
      };

    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        # empty modules would cause a failure at runtime
        assertion = cfg.settings.metricbeat.modules != [];
        message = "services.metricbeat: You must configure one or more modules.";
      }
    ];

    services.metricbeat.settings.metricbeat.modules = attrValues cfg.modules;

    systemd.services.metricbeat = {
      description = "metricbeat metrics shipper";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/metricbeat \
            -c ${settingsFormat.generate "metricbeat.yml" cfg.settings} \
            --path.data $STATE_DIRECTORY \
            --path.logs $LOGS_DIRECTORY \
            ;
        '';
        Restart = "always";
        DynamicUser = true;
        ProtectSystem = "strict";
        ProtectHome = "tmpfs";
        StateDirectory = "metricbeat";
        LogsDirectory = "metricbeat";
      };
    };
  };
}
