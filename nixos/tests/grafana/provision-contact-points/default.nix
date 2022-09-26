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
    provisionContactPointsNix = {
      services.grafana.provision = {
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

    provisionContactPointsYaml = {
      services.grafana.provision.alerting.contactPoints.path = ./provision-contact-points.yaml;
    };
  };

  nodes = builtins.listToAttrs (map (provisionType:
    nameValuePair provisionType (mkMerge [
    baseGrafanaConf
    (extraNodeConfs.${provisionType} or {})
  ])) [ "provisionContactPointsNix" "provisionContactPointsYaml" ]);

in {
  name = "grafana-provision-contact-points";

  meta = with maintainers; {
    maintainers = [ kfears willibutz ];
  };

  inherit nodes;

  testScript = ''
    start_all()
    with subtest("Successful contact point provision with Nix"):
        provisionContactPointsNix.wait_for_unit("grafana.service")
        provisionContactPointsNix.wait_for_open_port(3000)
        provisionContactPointsNix.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/v1/provisioning/contact-points | grep Test\ Contact\ Point"
        )
        provisionContactPointsNix.shutdown()

    with subtest("Successful contact point provision with YAML"):
        provisionContactPointsYaml.wait_for_unit("grafana.service")
        provisionContactPointsYaml.wait_for_open_port(3000)
        provisionContactPointsYaml.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/v1/provisioning/contact-points | grep Test\ Contact\ Point"
        )
        provisionContactPointsYaml.shutdown()
  '';
})) args
