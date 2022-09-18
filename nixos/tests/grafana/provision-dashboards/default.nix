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

    systemd.tmpfiles.rules = [
      "L /var/lib/grafana/dashboards/test.json 0700 grafana grafana - ${pkgs.writeText "test.json" (builtins.readFile ./test_dashboard.json)}"
    ];
  };

  extraNodeConfs = {
    provisionDashboardOld = {
      services.grafana.provision = {
        dashboards = [{ options.path = "/var/lib/grafana/dashboards"; }];
      };
    };

    provisionDashboardNix = {
      services.grafana.provision = {
        dashboards.settings = {
          apiVersion = 1;
          providers = [{
            name = "default";
            options.path = "/var/lib/grafana/dashboards";
          }];
        };
      };
    };

    provisionDashboardYaml = {
      services.grafana.provision.dashboards.path = ./provision-dashboards.yaml;
    };
  };

  nodes = builtins.listToAttrs (map (provisionType:
    nameValuePair provisionType (mkMerge [
    baseGrafanaConf
    (extraNodeConfs.${provisionType} or {})
  ])) [ "provisionDashboardOld" "provisionDashboardNix" "provisionDashboardYaml" ]);

in {
  name = "grafana-provision-dashboards";

  meta = with maintainers; {
    maintainers = [ kfears willibutz ];
  };

  inherit nodes;

  testScript = ''
    start_all()

    with subtest("Successful dashboard provision with Nix (old format)"):
        provisionDashboardOld.wait_for_unit("grafana.service")
        provisionDashboardOld.wait_for_open_port(3000)
        provisionDashboardOld.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/dashboards/uid/test_dashboard | grep Test\ Dashboard"
        )
        provisionDashboardOld.shutdown()

    with subtest("Successful dashboard provision with Nix (new format)"):
        provisionDashboardNix.wait_for_unit("grafana.service")
        provisionDashboardNix.wait_for_open_port(3000)
        provisionDashboardNix.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/dashboards/uid/test_dashboard | grep Test\ Dashboard"
        )
        provisionDashboardNix.shutdown()

    with subtest("Successful dashboard provision with YAML"):
        provisionDashboardYaml.wait_for_unit("grafana.service")
        provisionDashboardYaml.wait_for_open_port(3000)
        provisionDashboardYaml.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/dashboards/uid/test_dashboard | grep Test\ Dashboard"
        )
        provisionDashboardYaml.shutdown()
  '';
})) args
