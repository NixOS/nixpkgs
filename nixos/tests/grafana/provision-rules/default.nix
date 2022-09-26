args@{ pkgs, ... }:

(import ../../make-test-python.nix ({ lib, pkgs, ... }:

let
  inherit (lib) mkMerge nameValuePair maintainers;

  baseGrafanaConf = {
    services.grafana = {
      enable = true;
      addr = "localhost";
      analytics.reporting.enable = false;
      domain = "localhost";
      security = {
        adminUser = "testadmin";
        adminPassword = "snakeoilpwd";
      };
      provision.enable = true;
    };
  };

  extraNodeConfs = {
    provisionRulesNix = {
      services.grafana.provision = {
        alerting.rules.settings = {
          groups = [{
            name = "test_rule_group";
            folder = "test_folder";
            interval = "60s";
            rules = [{
              uid = "test_rule";
              title = "Test Rule";
              condition = "A";
              data = [{
                refId = "A";
                datasourceUid = "-100";
                model = {
                  conditions = [{
                    evaluator = {
                      params = [ 3 ];
                      type = "git";
                    };
                    operator.type = "and";
                    query.params = [ "A" ];
                    reducer.type = "last";
                    type = "query";
                  }];
                  datasource = {
                    type = "__expr__";
                    uid = "-100";
                  };
                  expression = "1==0";
                  intervalMs = 1000;
                  maxDataPoints = 43200;
                  refId = "A";
                  type = "math";
                };
              }];
              for = "60s";
            }];
          }];
        };
      };
    };

    provisionRulesYaml = {
      services.grafana.provision.alerting.rules.path = ./provision-rules.yaml;
    };
  };

  nodes = builtins.listToAttrs (map (provisionType:
    nameValuePair provisionType (mkMerge [
    baseGrafanaConf
    (extraNodeConfs.${provisionType} or {})
  ])) [ "provisionRulesNix" "provisionRulesYaml" ]);

in {
  name = "grafana-provision-rules";

  meta = with maintainers; {
    maintainers = [ kfears willibutz ];
  };

  inherit nodes;

  testScript = ''
    start_all()
    with subtest("Successful rule provision with Nix"):
        provisionRulesNix.wait_for_unit("grafana.service")
        provisionRulesNix.wait_for_open_port(3000)
        provisionRulesNix.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/v1/provisioning/alert-rules/test_rule | grep Test\ Rule"
        )
        provisionRulesNix.shutdown()

    with subtest("Successful rule provision with YAML"):
        provisionRulesYaml.wait_for_unit("grafana.service")
        provisionRulesYaml.wait_for_open_port(3000)
        provisionRulesYaml.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/v1/provisioning/alert-rules/test_rule | grep Test\ Rule"
        )
        provisionRulesYaml.shutdown()
  '';
})) args
