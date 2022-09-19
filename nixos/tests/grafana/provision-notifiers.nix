args@{ pkgs, ... }:

(import ../make-test-python.nix ({ lib, pkgs, ... }:

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
    provisionNotifiers = {
      services.grafana.provision = {
        notifiers = [{
          uid = "test_notifiers";
          name = "Test Notifiers";
          type = "email";
          settings = {
            singleEmail = true;
            addresses = "test@test.com";
          };
        }];
      };
    };
  };

  nodes = builtins.listToAttrs (map (provisionType:
    nameValuePair provisionType (mkMerge [
    baseGrafanaConf
    (extraNodeConfs.${provisionType} or {})
  ])) [ "provisionNotifiers" ]);

in {
  name = "grafana-provision-notifiers";

  meta = with maintainers; {
    maintainers = [ kfears willibutz ];
  };

  inherit nodes;

  testScript = ''
    start_all()
    with subtest("Successful notifiers provision with Nix"):
        provisionNotifiers.wait_for_unit("grafana.service")
        provisionNotifiers.wait_for_open_port(3000)
        provisionNotifiers.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/alert-notifications/uid/test_notifiers | grep Test\ Notifiers"
        )
        provisionNotifiers.shutdown()
  '';
})) args
