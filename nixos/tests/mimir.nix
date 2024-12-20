import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "mimir";
    nodes = {
      server =
        { ... }:
        {
          environment.systemPackages = [ pkgs.jq ];
          services.mimir.enable = true;
          services.mimir.configuration = {
            ingester.ring.replication_factor = 1;
          };

          services.telegraf.enable = true;
          services.telegraf.extraConfig = {
            agent.interval = "1s";
            agent.flush_interval = "1s";
            inputs.exec = {
              commands = [
                "${pkgs.coreutils}/bin/echo 'foo i=42i'"
              ];
              data_format = "influx";
            };
            outputs = {
              http = {
                # test remote write
                url = "http://localhost:8080/api/v1/push";

                # Data format to output.
                data_format = "prometheusremotewrite";

                headers = {
                  Content-Type = "application/x-protobuf";
                  Content-Encoding = "snappy";
                  X-Scope-OrgID = "nixos";
                  X-Prometheus-Remote-Write-Version = "0.1.0";
                };
              };
            };
          };
        };
    };

    testScript = ''
      start_all()
      server.wait_for_unit("mimir.service")
      server.wait_for_unit("telegraf.service")
      server.wait_for_open_port(8080)
      server.wait_until_succeeds(
          "curl -H 'X-Scope-OrgID: nixos' http://127.0.0.1:8080/prometheus/api/v1/label/host/values | jq -r '.data[0]' | grep server"
      )
    '';
  }
)
