{ ... }:

let
  grpcPort = 19090;
  queryPort = 9090;
  garagePort = 9000;
  pushgwPort = 9091;
  frontPort = 9092;

  s3 = {
    accessKey = "GKaaaaaaaaaaaaaaaaaaaaaaaa";
    secretKey = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
  };

  objstore.config = {
    type = "S3";
    config = {
      bucket = "thanos-bucket";
      endpoint = "garage:${toString garagePort}";
      region = "garage";
      access_key = s3.accessKey;
      secret_key = s3.secretKey;
      insecure = true;
      signature_version2 = false;
      put_user_metadata = { };
      http_config = {
        idle_conn_timeout = "0s";
        insecure_skip_verify = false;
      };
      trace = {
        enable = false;
      };
    };
  };
in
{
  name = "thanos";

  nodes = {
    prometheus =
      { pkgs, ... }:
      {
        virtualisation.diskSize = 2 * 1024;
        virtualisation.memorySize = 2048;
        environment.systemPackages = [
          pkgs.grpc-health-probe
          pkgs.jq
        ];
        networking.firewall.allowedTCPPorts = [ grpcPort ];
        services.prometheus = {
          enable = true;
          enableReload = true;
          settings = {
            scrape_configs = [
              {
                job_name = "prometheus";
                static_configs = [
                  {
                    targets = [ "127.0.0.1:${toString queryPort}" ];
                    labels = {
                      instance = "localhost";
                    };
                  }
                ];
              }
              {
                job_name = "pushgateway";
                scrape_interval = "1s";
                static_configs = [
                  {
                    targets = [ "127.0.0.1:${toString pushgwPort}" ];
                  }
                ];
              }
            ];
            rule_files = [
              (pkgs.writeText "prometheus-rules.yml" ''
                groups:
                  - name: test
                    rules:
                      - record: testrule
                        expr: count(up{job="prometheus"})
              '')
            ];
            global = {
              external_labels = {
                some_label = "required by thanos";
              };
            };
          };
          extraFlags = [
            # Required by thanos
            "--storage.tsdb.min-block-duration=5s"
            "--storage.tsdb.max-block-duration=5s"
          ];
        };
        services.prometheus.pushgateway = {
          enable = true;
          web.listen-address = ":${toString pushgwPort}";
          persistMetrics = true;
          persistence.interval = "1s";
          stateDir = "prometheus-pushgateway";
        };
        services.thanos = {
          sidecar = {
            enable = true;
            grpc-address = "0.0.0.0:${toString grpcPort}";
            inherit objstore;
          };

          # TODO: Add some tests for these services:
          #rule = {
          #  enable = true;
          #  http-address = "0.0.0.0:19194";
          #  grpc-address = "0.0.0.0:19193";
          #  query.addresses = [
          #    "localhost:19191"
          #  ];
          #  labels = {
          #    just = "some";
          #    nice = "labels";
          #  };
          #};
          #
          #receive = {
          #  http-address = "0.0.0.0:19195";
          #  enable = true;
          #  labels = {
          #    just = "some";
          #    nice = "labels";
          #  };
          #};
        };
        # Adds a "specialisation" of the above config which allows us to
        # "switch" to it and see if the services.prometheus.enableReload
        # functionality actually reloads the prometheus service instead of
        # restarting it.
        specialisation = {
          "prometheus-config-change" = {
            configuration = {
              environment.systemPackages = [ pkgs.yq ];

              # This configuration just adds a new prometheus job
              # to scrape the node_exporter metrics of the garage machine.
              services.prometheus = {
                settings.scrape_configs = [
                  {
                    job_name = "garage-node_exporter";
                    static_configs = [
                      {
                        targets = [ "garage:9100" ];
                      }
                    ];
                  }
                ];
              };
            };
          };
        };
      };

    query =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.jq ];
        services.thanos.query = {
          enable = true;
          http-address = "0.0.0.0:${toString queryPort}";
          endpoints = [
            "prometheus:${toString grpcPort}"
          ];
        };
        services.thanos.query-frontend = {
          enable = true;
          http-address = "0.0.0.0:${toString frontPort}";
          query-frontend.downstream-url = "http://127.0.0.1:${toString queryPort}";
        };
      };

    store =
      { pkgs, ... }:
      {
        virtualisation.diskSize = 2 * 1024;
        virtualisation.memorySize = 2048;
        environment.systemPackages = with pkgs; [
          grpc-health-probe
          jq
          thanos
        ];
        services.thanos.store = {
          enable = true;
          http-address = "0.0.0.0:10902";
          grpc-address = "0.0.0.0:${toString grpcPort}";
          inherit objstore;
          sync-block-duration = "1s";
        };
        services.thanos.compact = {
          enable = true;
          http-address = "0.0.0.0:10903";
          inherit objstore;
          consistency-delay = "5s";
        };
        services.thanos.query = {
          enable = true;
          http-address = "0.0.0.0:${toString queryPort}";
          endpoints = [
            "localhost:${toString grpcPort}"
          ];
        };
      };

    garage =
      { pkgs, ... }:
      {
        # Garage requires at least 1GiB of free disk space to run.
        virtualisation = {
          diskSize = 2 * 1024;
        };
        networking.firewall.allowedTCPPorts = [ garagePort ];

        services.garage = {
          enable = true;
          package = pkgs.garage_2;
          settings = {
            rpc_bind_addr = "127.0.0.1:3901";
            rpc_public_addr = "127.0.0.1:3901";
            rpc_secret = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
            replication_factor = 1;

            s3_api = {
              s3_region = "garage";
              api_bind_addr = "0.0.0.0:${toString garagePort}";
            };
          };
        };

        services.prometheus.exporters.node = {
          enable = true;
          openFirewall = true;
        };
      };
  };

  testScript =
    { nodes, ... }:
    ''
      # Before starting the other machines we first make sure that our S3 service is online
      # and has a bucket added for thanos:
      garage.start()
      garage.wait_for_unit("garage.service")
      garage.wait_for_open_port(3901)
      garage_node_id = garage.succeed("garage status | tail -n1 | awk '{ print $1 }'")
      garage.succeed(
          f"garage layout assign -c 100MB -z garage {garage_node_id}",
          "garage layout apply --version 1",
          "garage key import ${s3.accessKey} ${s3.secretKey} --yes",
          "garage bucket create thanos-bucket",
          "garage bucket allow --read --write --owner thanos-bucket --key ${s3.accessKey}",
      )
      garage.wait_for_open_port(${toString garagePort})

      # Now that the S3 service has started we can start the other machines:
      for machine in prometheus, query, store:
          machine.start()

      # Check if prometheus responds to requests:
      prometheus.wait_for_unit("prometheus.service")

      prometheus.wait_for_open_port(${toString queryPort})
      prometheus.succeed("curl -sf http://127.0.0.1:${toString queryPort}/metrics")

      prometheus.wait_until_succeeds("journalctl -o cat -u thanos-sidecar.service | grep 'listening for serving gRPC'")

      store.wait_until_succeeds("journalctl -o cat -u thanos-store.service | grep 'listening for serving gRPC'")

      for machine in prometheus, store:
        machine.wait_until_succeeds("grpc-health-probe -addr 127.0.0.1:${toString grpcPort}")

      # Let's test if pushing a metric to the pushgateway succeeds:
      prometheus.wait_for_unit("pushgateway.service")
      prometheus.succeed(
          "echo 'some_metric 3.14' | "
          + "curl -f --data-binary \@- "
          + "http://127.0.0.1:${toString pushgwPort}/metrics/job/some_job"
      )

      # Now check whether that metric gets ingested by prometheus.
      # Since we'll check for the metric several times on different machines
      # we abstract the test using the following function:

      # Function to check if the metric "some_metric" has been received and returns the correct value.
      def wait_for_metric(machine):
          return machine.wait_until_succeeds(
              "curl -sf 'http://127.0.0.1:${toString queryPort}/api/v1/query?query=some_metric' | "
              + "jq '.data.result[0].value[1]' | grep '\"3.14\"'"
          )


      wait_for_metric(prometheus)

      # Let's test if the pushgateway persists metrics to the configured location.
      prometheus.wait_until_succeeds("test -e /var/lib/prometheus-pushgateway/metrics")

      # Test thanos
      prometheus.wait_for_unit("thanos-sidecar.service")

      # Test if the Thanos query service can correctly retrieve the metric that was send above.
      query.wait_for_unit("thanos-query.service")
      wait_for_metric(query)

      # Test Thanos query frontend service
      query.wait_for_unit("thanos-query-frontend.service")
      query.succeed("curl -sS http://localhost:${toString frontPort}/-/healthy")

      # Test if the Thanos sidecar has correctly uploaded its TSDB to S3, if the
      # Thanos storage service has correctly downloaded it from S3 and if the Thanos
      # query service running on $store can correctly retrieve the metric:
      store.wait_for_unit("thanos-store.service")
      wait_for_metric(store)

      store.wait_for_unit("thanos-compact.service")

      # Test if the Thanos bucket command is able to retrieve blocks from the S3 bucket
      # and check if the blocks have the correct labels:
      store.succeed(
          "thanos tools bucket ls "
          + "--objstore.config-file=${nodes.store.config.services.thanos.store.objstore.config-file} "
          + "--output=json | "
          + "jq .thanos.labels.some_label | "
          + "grep 'required by thanos'"
      )
    '';
}
