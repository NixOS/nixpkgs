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
    provisionMuteTimingsNix = {
      services.grafana.provision = {
        alerting.muteTimings.settings = {
          muteTimes = [{
            name = "Test Mute Timing";
          }];
        };
      };
    };

    provisionMuteTimingsYaml = {
      services.grafana.provision.alerting.muteTimings.path = ./provision-mute-timings.yaml;
    };
  };

  nodes = builtins.listToAttrs (map (provisionType:
    nameValuePair provisionType (mkMerge [
    baseGrafanaConf
    (extraNodeConfs.${provisionType} or {})
  ])) [ "provisionMuteTimingsNix" "provisionMuteTimingsYaml" ]);

in {
  name = "grafana-provision-mute-timings";

  meta = with maintainers; {
    maintainers = [ kfears willibutz ];
  };

  inherit nodes;

  testScript = ''
    start_all()
    with subtest("Successful mute timings provision with Nix"):
        provisionMuteTimingsNix.wait_for_unit("grafana.service")
        provisionMuteTimingsNix.wait_for_open_port(3000)
        provisionMuteTimingsNix.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/v1/provisioning/mute-timings | grep Test\ Mute\ Timing"
        )
        provisionMuteTimingsNix.shutdown()

    with subtest("Successful mute timings provision with YAML"):
        provisionMuteTimingsYaml.wait_for_unit("grafana.service")
        provisionMuteTimingsYaml.wait_for_open_port(3000)
        provisionMuteTimingsYaml.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/v1/provisioning/mute-timings | grep Test\ Mute\ Timing"
        )
        provisionMuteTimingsYaml.shutdown()
  '';
})) args
