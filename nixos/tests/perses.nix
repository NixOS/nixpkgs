{ pkgs, lib, ... }:

{
  name = "perses";

  meta.maintainers = with lib.maintainers; [ fooker ];

  nodes.prometheus = {
    services.prometheus.enable = true;
    networking.firewall.allowedTCPPorts = [ 9090 ];
  };

  nodes.machine = {
    services.perses = {
      enable = true;

      settings.provisioning.folders = [
        (pkgs.writeTextDir "perses-test-provision-project.yaml" ''
          kind: "Project"
          metadata:
            name: "my-project"
        '')
        (pkgs.writeTextDir "perses-test-provision-datasource.yaml" ''
          kind: "Datasource"
          metadata:
            name: "my-prometheus"
            project: "my-project"
          spec:
            default: true
            plugin:
              kind: "PrometheusDatasource"
              spec:
                proxy:
                  kind: "HTTPProxy"
                  spec:
                    url: "http://prometheus:9090/"
        '')
      ];
    };
  };

  testScript = ''
    start_all()

    prometheus.wait_for_unit("prometheus.service")
    prometheus.wait_for_open_port(9090)

    with subtest("Perses starts"):
        machine.wait_for_unit("perses.service")
        machine.wait_for_open_port(8080)
        machine.succeed("percli login http://127.0.0.1:8080")
        machine.succeed("percli version")
        machine.succeed("percli config")
        machine.succeed("percli plugin list | grep 'Prometheus'")

    with subtest("Query resources"):
        machine.succeed("percli get projects | grep my-project")
        machine.succeed("percli project my-project")
        machine.succeed("percli get datasources | grep my-prometheus")
        machine.succeed("curl --fail -s 127.0.0.1:8080/api/v1/projects/my-project/datasources/my-prometheus")

    with subtest("Datasource check"):
        machine.succeed("curl --fail -s http://127.0.0.1:8080/proxy/projects/my-project/datasources/my-prometheus/api/v1/status/config")
  '';
}
