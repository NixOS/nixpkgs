{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.vmalert;

  format = pkgs.formats.yaml { };

  mkConfOpts =
    settings:
    concatStringsSep " \\\n" (mapAttrsToList mkLine (filterAttrs (_: v: v != false) settings));
  confType =
    with types;
    let
      valueType = oneOf [
        bool
        int
        path
        str
      ];
    in
    attrsOf (either valueType (listOf valueType));

  mkLine =
    key: value:
    if value == true then
      "-${key}"
    else if isList value then
      concatMapStringsSep " " (v: "-${key}=${escapeShellArg (toString v)}") value
    else
      "-${key}=${escapeShellArg (toString value)}";

  vmalertName = name: "vmalert" + lib.optionalString (name != "") ("-" + name);
  enabledInstances = lib.filterAttrs (name: conf: conf.enable) config.services.vmalert.instances;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "vmalert" "enable" ]
      [ "services" "vmalert" "instances" "" "enable" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "vmalert" "rules" ]
      [ "services" "vmalert" "instances" "" "rules" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "vmalert" "settings" ]
      [ "services" "vmalert" "instances" "" "settings" ]
    )
  ];

  # interface
  options.services.vmalert.package = mkPackageOption pkgs "victoriametrics" { };

  options.services.vmalert.instances = mkOption {
    default = { };

    description = ''
      Define multiple instances of vmalert.
    '';

    type = types.attrsOf (
      types.submodule (
        { name, config, ... }:
        {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Wether to enable VictoriaMetrics's `vmalert`.

                `vmalert` evaluates alerting and recording rules against a data source, sends notifications via Alertmanager.
              '';
            };

            settings = mkOption {
              type = types.submodule {
                freeformType = confType;
                options = {

                  "datasource.url" = mkOption {
                    type = types.nonEmptyStr;
                    example = "http://localhost:8428";
                    description = ''
                      Datasource compatible with Prometheus HTTP API.
                    '';
                  };

                  "notifier.url" = mkOption {
                    type = with types; listOf nonEmptyStr;
                    default = [ ];
                    example = [ "http://127.0.0.1:9093" ];
                    description = ''
                      Prometheus Alertmanager URL. List all Alertmanager URLs if it runs in the cluster mode to ensure high availability.
                    '';
                  };

                  "rule" = mkOption {
                    type = with types; listOf path;
                    description = ''
                      Path to the files with alerting and/or recording rules.

                      ::: {.note}
                      Consider using the {option}`services.vmalert.instances.<name>.rules` option as a convenient alternative for declaring rules
                      directly in the `nix` language.
                      :::
                    '';
                  };

                };
              };
              default = { };
              example = {
                "datasource.url" = "http://localhost:8428";
                "datasource.disableKeepAlive" = true;
                "datasource.showURL" = false;
                "rule" = [
                  "http://<some-server-addr>/path/to/rules"
                  "dir/*.yaml"
                ];
              };
              description = ''
                `vmalert` configuration, passed via command line flags. Refer to
                <https://github.com/VictoriaMetrics/VictoriaMetrics/blob/master/app/vmalert/README.md#configuration>
                for details on supported values.
              '';
            };

            rules = mkOption {
              type = format.type;
              default = { };
              example = {
                group = [
                  {
                    name = "TestGroup";
                    rules = [
                      {
                        alert = "ExampleAlertAlwaysFiring";
                        expr = ''
                          sum by(job)
                          (up == 1)
                        '';
                      }
                    ];
                  }
                ];
              };
              description = ''
                A list of the given alerting or recording rules against configured `"datasource.url"` compatible with
                Prometheus HTTP API for `vmalert` to execute. Refer to
                <https://github.com/VictoriaMetrics/VictoriaMetrics/blob/master/app/vmalert/README.md#rules>
                for details on supported values.
              '';
            };
          };

          config = {
            settings.rule = [
              "/etc/${vmalertName name}/rules.yml"
            ];
          };
        }
      )
    );
  };

  # implementation
  config = mkIf (enabledInstances != { }) {
    environment.etc = lib.mapAttrs' (
      name:
      { rules, ... }:
      lib.nameValuePair "${vmalertName name}/rules.yml" {
        source = format.generate "rules.yml" rules;
      }
    ) enabledInstances;

    systemd.services = lib.mapAttrs' (
      name:
      { settings, ... }:
      let
        name' = vmalertName name;
      in
      lib.nameValuePair name' {
        description = "vmalert service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        reloadTriggers = [ config.environment.etc."${name'}/rules.yml".source ];

        serviceConfig = {
          DynamicUser = true;
          Restart = "on-failure";
          ExecStart = "${cfg.package}/bin/vmalert ${mkConfOpts settings}";
          ExecReload = ''${pkgs.coreutils}/bin/kill -SIGHUP "$MAINPID"'';
        };
      }
    ) enabledInstances;
  };
}
