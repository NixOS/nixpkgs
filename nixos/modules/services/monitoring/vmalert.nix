{ config, pkgs, lib, ... }: with lib;
let
  cfg = config.services.vmalert;

  format = pkgs.formats.yaml {};

  confOpts = concatStringsSep " \\\n" (mapAttrsToList mkLine (filterAttrs (_: v: v != false) cfg.settings));
  confType = with types;
    let
      valueType = oneOf [ bool int path str ];
    in
    attrsOf (either valueType (listOf valueType));

  mkLine = key: value:
    if value == true then "-${key}"
    else if isList value then concatMapStringsSep " " (v: "-${key}=${escapeShellArg (toString v)}") value
    else "-${key}=${escapeShellArg (toString value)}"
  ;
in
{
  # interface
  options.services.vmalert = {
    enable = mkEnableOption (mdDoc "vmalert");

    package = mkPackageOption pkgs "victoriametrics" { };

    settings = mkOption {
      type = types.submodule {
        freeformType = confType;
        options = {

          "datasource.url" = mkOption {
            type = types.nonEmptyStr;
            example = "http://localhost:8428";
            description = mdDoc ''
              Datasource compatible with Prometheus HTTP API.
            '';
          };

          "notifier.url" = mkOption {
            type = with types; listOf nonEmptyStr;
            default = [];
            example = [ "http://127.0.0.1:9093" ];
            description = mdDoc ''
              Prometheus Alertmanager URL. List all Alertmanager URLs if it runs in the cluster mode to ensure high availability.
            '';
          };

          "rule" = mkOption {
            type = with types; listOf path;
            description = mdDoc ''
              Path to the files with alerting and/or recording rules.

              ::: {.note}
              Consider using the {option}`services.vmalert.rules` option as a convenient alternative for declaring rules
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
      description = mdDoc ''
        `vmalert` configuration, passed via command line flags. Refer to
        <https://github.com/VictoriaMetrics/VictoriaMetrics/blob/master/app/vmalert/README.md#configuration>
        for details on supported values.
      '';
    };

    rules = mkOption {
      type = format.type;
      default = {};
      example = {
        group = [
          { name = "TestGroup";
            rules = [
              { alert = "ExampleAlertAlwaysFiring";
                expr = ''
                  sum by(job)
                  (up == 1)
                '';
              }
            ];
          }
        ];
      };
      description = mdDoc ''
        A list of the given alerting or recording rules against configured `"datasource.url"` compatible with
        Prometheus HTTP API for `vmalert` to execute. Refer to
        <https://github.com/VictoriaMetrics/VictoriaMetrics/blob/master/app/vmalert/README.md#rules>
        for details on supported values.
      '';
    };
  };

  # implementation
  config = mkIf cfg.enable {

    environment.etc."vmalert/rules.yml".source = format.generate "rules.yml" cfg.rules;

    services.vmalert.settings.rule = [
      "/etc/vmalert/rules.yml"
    ];

    systemd.services.vmalert = {
      description = "vmalert service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      reloadTriggers = [ config.environment.etc."vmalert/rules.yml".source ];

      serviceConfig = {
        DynamicUser = true;
        Restart = "on-failure";
        ExecStart = "${cfg.package}/bin/vmalert ${confOpts}";
        ExecReload = ''${pkgs.coreutils}/bin/kill -SIGHUP "$MAINPID"'';
      };
    };
  };
}
