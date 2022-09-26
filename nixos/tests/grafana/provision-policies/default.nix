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
    provisionPoliciesNix = {
      services.grafana.provision = {
        alerting.policies.settings = {
          policies = [{
            receiver = "Test Contact Point";
          }];
        };
        alerting.contactPoints.settings = {
          contactPoints = [{
            name = "Test Contact Point";
            receivers = [{
              uid = "test_contact_point";
              type = "prometheus-alertmanager";
              settings.url = "http://localhost:9000";
            }];
          }];
        };
      };
    };

    provisionPoliciesYaml = {
      services.grafana.provision.alerting.policies.path = ./provision-policies.yaml;
      services.grafana.provision.alerting.contactPoints.path = ./provision-contact-points.yaml;
    };
  };

  nodes = builtins.listToAttrs (map (provisionType:
    nameValuePair provisionType (mkMerge [
    baseGrafanaConf
    (extraNodeConfs.${provisionType} or {})
  ])) [ "provisionPoliciesNix" "provisionPoliciesYaml" ]);

in {
  name = "grafana-provision-policies";

  meta = with maintainers; {
    maintainers = [ kfears willibutz ];
  };

  inherit nodes;

  testScript = ''
    start_all()
    with subtest("Successful policy provision with Nix"):
        provisionPoliciesNix.wait_for_unit("grafana.service")
        provisionPoliciesNix.wait_for_open_port(3000)
        provisionPoliciesNix.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/v1/provisioning/contact-points | grep Test\ Contact\ Point"
        )
        provisionPoliciesNix.shutdown()

    with subtest("Successful policy provision with YAML"):
        provisionPoliciesYaml.wait_for_unit("grafana.service")
        provisionPoliciesYaml.wait_for_open_port(3000)
        provisionPoliciesYaml.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/v1/provisioning/contact-points | grep Test\ Contact\ Point"
        )
        provisionPoliciesYaml.shutdown()
  '';
})) args
