let
  grpcPort   = 19090;
  queryPort  =  9090;
  minioPort  =  9000;
  pushgwPort =  9091;

  s3 = {
    accessKey = "BKIKJAA5BMMU2RHO6IBB";
    secretKey = "V7f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12";
  };

  objstore.config = {
    type = "S3";
    config = {
      bucket = "thanos-bucket";
      endpoint = "s3:${toString minioPort}";
      region =  "us-east-1";
      access_key = s3.accessKey;
      secret_key = s3.secretKey;
      insecure = true;
      signature_version2 = false;
      put_user_metadata = {};
      http_config = {
        idle_conn_timeout = "0s";
        insecure_skip_verify = false;
      };
      trace = {
        enable = false;
      };
    };
  };

in import ./make-test-python.nix {
  name = "prometheus";

  nodes = {
    prometheus = { pkgs, ... }: {
      virtualisation.diskSize = 2 * 1024;
      virtualisation.memorySize = 2048;
      environment.systemPackages = [ pkgs.jq ];
      networking.firewall.allowedTCPPorts = [ grpcPort ];
      services.prometheus = {
        enable = true;
        scrapeConfigs = [
          {
            job_name = "prometheus";
            static_configs = [
              {
                targets = [ "127.0.0.1:${toString queryPort}" ];
                labels = { instance = "localhost"; };
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
        rules = [
          ''
            groups:
              - name: test
                rules:
                  - record: testrule
                    expr: count(up{job="prometheus"})
          ''
        ];
        globalConfig = {
          external_labels = {
            some_label = "required by thanos";
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
    };

    query = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.jq ];
      services.thanos.query = {
        enable = true;
        http-address = "0.0.0.0:${toString queryPort}";
        store.addresses = [
          "prometheus:${toString grpcPort}"
        ];
      };
    };

    store = { pkgs, ... }: {
      virtualisation.diskSize = 2 * 1024;
      virtualisation.memorySize = 2048;
      environment.systemPackages = with pkgs; [ jq thanos ];
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
        store.addresses = [
          "localhost:${toString grpcPort}"
        ];
      };
    };

    s3 = { pkgs, ... } : {
      # Minio requires at least 1GiB of free disk space to run.
      virtualisation = {
        diskSize = 2 * 1024;
        memorySize = 1024;
      };
      networking.firewall.allowedTCPPorts = [ minioPort ];

      services.minio = {
        enable = true;
        inherit (s3) accessKey secretKey;
      };

      environment.systemPackages = [ pkgs.minio-client ];
    };
  };

  testScript = { nodes, ... } : ''
    # Before starting the other machines we first make sure that our S3 service is online
    # and has a bucket added for thanos:
    s3.start()
    s3.wait_for_unit("minio.service")
    s3.wait_for_open_port(${toString minioPort})
    s3.succeed(
        "mc config host add minio "
        + "http://localhost:${toString minioPort} "
        + "${s3.accessKey} ${s3.secretKey} --api s3v4",
        "mc mb minio/thanos-bucket",
    )

    # Now that s3 has started we can start the other machines:
    for machine in prometheus, query, store:
        machine.start()

    # Check if prometheus responds to requests:
    prometheus.wait_for_unit("prometheus.service")
    prometheus.wait_for_open_port(${toString queryPort})
    prometheus.succeed("curl -sf http://127.0.0.1:${toString queryPort}/metrics")

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
