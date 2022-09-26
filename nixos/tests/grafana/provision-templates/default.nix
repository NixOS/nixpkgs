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
    provisionTemplatesNix = {
      services.grafana.provision = {
        alerting.templates.settings = {
          templates = [{
            name = "Test Template";
            template = "Test message";
          }];
        };
      };
    };

    provisionTemplatesYaml = {
      services.grafana.provision.alerting.templates.path = ./provision-templates.yaml;
    };
  };

  nodes = builtins.listToAttrs (map (provisionType:
    nameValuePair provisionType (mkMerge [
    baseGrafanaConf
    (extraNodeConfs.${provisionType} or {})
  ])) [ "provisionTemplatesNix" "provisionTemplatesYaml" ]);

in {
  name = "grafana-provision-rules";

  meta = with maintainers; {
    maintainers = [ kfears willibutz ];
  };

  inherit nodes;

  testScript = ''
    start_all()
    with subtest("Successful template provision with Nix"):
        provisionTemplatesNix.wait_for_unit("grafana.service")
        provisionTemplatesNix.wait_for_open_port(3000)
        provisionTemplatesNix.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/v1/provisioning/templates | grep Test\ Template"
        )
        provisionTemplatesNix.shutdown()

    with subtest("Successful template provision with YAML"):
        provisionTemplatesYaml.wait_for_unit("grafana.service")
        provisionTemplatesYaml.wait_for_open_port(3000)
        provisionTemplatesYaml.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/v1/provisioning/templates | grep Test\ Template"
        )
        provisionTemplatesYaml.shutdown()
  '';
})) args
