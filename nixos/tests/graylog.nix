import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "graylog";
  meta.maintainers = with lib.maintainers; [ ];

  nodes.machine = { pkgs, ... }: {
    virtualisation.memorySize = 4096;
    virtualisation.diskSize = 4096;

    services.mongodb.enable = true;
    services.elasticsearch.enable = true;
    services.elasticsearch.package = pkgs.elasticsearch-oss;
    services.elasticsearch.extraConf = ''
      network.publish_host: 127.0.0.1
      network.bind_host: 127.0.0.1
    '';

    services.graylog = {
      enable = true;
      passwordSecret = "YGhZ59wXMrYOojx5xdgEpBpDw2N6FbhM4lTtaJ1KPxxmKrUvSlDbtWArwAWMQ5LKx1ojHEVrQrBMVRdXbRyZLqffoUzHfssc";
      elasticsearchHosts = [ "http://localhost:9200" ];

      # `echo -n "nixos" | shasum -a 256`
      rootPasswordSha2 = "6ed332bcfa615381511d4d5ba44a293bb476f368f7e9e304f0dff50230d1a85b";
    };

    environment.systemPackages = [ pkgs.jq ];

    systemd.services.graylog.path = [ pkgs.netcat ];
    systemd.services.graylog.preStart = ''
      until nc -z localhost 9200; do
        sleep 2
      done
    '';
  };

  testScript = let
    payloads.login = pkgs.writeText "login.json" (builtins.toJSON {
      host = "127.0.0.1:9000";
      username = "admin";
      password = "nixos";
    });

    payloads.input = pkgs.writeText "input.json" (builtins.toJSON {
      title = "Demo";
      global = false;
      type = "org.graylog2.inputs.gelf.udp.GELFUDPInput";
      node = "@node@";
      configuration = {
        bind_address = "0.0.0.0";
        decompress_size_limit = 8388608;
        number_worker_threads = 1;
        override_source = null;
        port = 12201;
        recv_buffer_size = 262144;
      };
    });

    payloads.gelf_message = pkgs.writeText "gelf.json" (builtins.toJSON {
      host = "example.org";
      short_message = "A short message";
      full_message = "A long message";
      version = "1.1";
      level = 5;
      facility = "Test";
    });
  in ''
    machine.start()
    machine.wait_for_unit("graylog.service")
    machine.wait_for_open_port(9000)
    machine.succeed("curl -sSfL http://127.0.0.1:9000/")

    session = machine.succeed(
        "curl -X POST "
        + "-sSfL http://127.0.0.1:9000/api/system/sessions "
        + "-d $(cat ${payloads.login}) "
        + "-H 'Content-Type: application/json' "
        + "-H 'Accept: application/json' "
        + "-H 'x-requested-by: cli' "
        + "| jq .session_id | xargs echo"
    ).rstrip()

    machine.succeed(
        "curl -X POST "
        + f"-sSfL http://127.0.0.1:9000/api/system/inputs -u {session}:session "
        + '-d $(cat ${payloads.input} | sed -e "s,@node@,$(cat /var/lib/graylog/server/node-id),") '
        + "-H 'Accept: application/json' "
        + "-H 'Content-Type: application/json' "
        + "-H 'x-requested-by: cli' "
    )

    machine.wait_until_succeeds(
        "test \"$(curl -sSfL 'http://127.0.0.1:9000/api/cluster/inputstates' "
        + f"-u {session}:session "
        + "-H 'Accept: application/json' "
        + "-H 'Content-Type: application/json' "
        + "-H 'x-requested-by: cli'"
        + "| jq 'to_entries[]|.value|.[0]|.state' | xargs echo"
        + ')" = "RUNNING"'
    )

    machine.succeed(
        "echo -n $(cat ${payloads.gelf_message}) | nc -w10 -u 127.0.0.1 12201"
    )

    machine.succeed(
        'test "$(curl -X GET '
        + "-sSfL 'http://127.0.0.1:9000/api/search/universal/relative?query=*' "
        + f"-u {session}:session "
        + "-H 'Accept: application/json' "
        + "-H 'Content-Type: application/json' "
        + "-H 'x-requested-by: cli'"
        + ' | jq \'.total_results\' | xargs echo)" = "1"'
    )
  '';
})
