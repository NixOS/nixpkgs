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
    provisionDatasourceOld = {
      services.grafana.provision = {
        datasources = [{
          name = "Test Datasource";
          type = "testdata";
          access = "proxy";
          uid = "test_datasource";
        }];
      };
    };

    provisionDatasourceNix = {
      services.grafana.provision = {
        datasources.settings = {
          apiVersion = 1;
          datasources = [{
            name = "Test Datasource";
            type = "testdata";
            access = "proxy";
            uid = "test_datasource";
          }];
        };
      };
    };

    provisionDatasourceYaml = {
      services.grafana.provision.datasources.path = ./provision-datasources.yaml;
    };
  };

  nodes = builtins.listToAttrs (map (provisionType:
    nameValuePair provisionType (mkMerge [
    baseGrafanaConf
    (extraNodeConfs.${provisionType} or {})
  ])) [ "provisionDatasourceOld" "provisionDatasourceNix" "provisionDatasourceYaml" ]);

in {
  name = "grafana-provision-datasources";

  meta = with maintainers; {
    maintainers = [ kfears willibutz ];
  };

  inherit nodes;

  testScript = ''
    start_all()

    with subtest("Successful datasource provision with Nix (old format)"):
        provisionDatasourceOld.wait_for_unit("grafana.service")
        provisionDatasourceOld.wait_for_open_port(3000)
        provisionDatasourceOld.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/datasources/uid/test_datasource | grep Test\ Datasource"
        )
        provisionDatasourceOld.shutdown()

    with subtest("Successful datasource provision with Nix (new format)"):
        provisionDatasourceNix.wait_for_unit("grafana.service")
        provisionDatasourceNix.wait_for_open_port(3000)
        provisionDatasourceNix.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/datasources/uid/test_datasource | grep Test\ Datasource"
        )
        provisionDatasourceNix.shutdown()

    with subtest("Successful datasource provision with YAML"):
        provisionDatasourceYaml.wait_for_unit("grafana.service")
        provisionDatasourceYaml.wait_for_open_port(3000)
        provisionDatasourceYaml.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/datasources/uid/test_datasource | grep Test\ Datasource"
        )
        provisionDatasourceYaml.shutdown()
  '';
})) args
