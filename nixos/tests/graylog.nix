# Run this test with NIXPKGS_ALLOW_UNFREE=1
{ lib, pkgs, ... }:
{
  name = "graylog";
  meta.maintainers = with lib.maintainers; [
    bbenno
    robertjakub
  ];

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.memorySize = 4096;
      virtualisation.diskSize = 1024 * 6;

      # use community-edition for tests
      services.mongodb.package = pkgs.mongodb-ce;

      services.opensearch = {
        enable = true;
        extraJavaOptions = [ "-Djava.net.preferIPv4Stack=true" ];
        settings.network.host = "127.0.0.1";
      };

      services.graylog = {
        enable = true;
        enableLocalMongoDB = true;
        elasticsearchHosts = [ "http://127.0.0.1:9200" ];
        passwordSecretFile = "/run/graylog-passwordsecret";
        rootPasswordSha2File = "/run/graylog-rootpasswordsha2";
      };

      environment.systemPackages = [ pkgs.jq ];

      systemd.services.graylog.path = [ pkgs.netcat ];
      systemd.services.graylog.preStart = ''
        until nc -z 127.0.0.1 9200; do
          sleep 2
        done
      '';
    };

  testScript =
    let
      payloads.login = pkgs.writeText "login.json" (
        builtins.toJSON {
          host = "127.0.0.1:9000";
          username = "admin";
          password = "nixos";
        }
      );

      payloads.input = pkgs.writeText "input.json" (
        builtins.toJSON {
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
        }
      );

      payloads.gelf_message = pkgs.writeText "gelf.json" (
        builtins.toJSON {
          host = "example.org";
          short_message = "A short message";
          full_message = "A long message";
          version = "1.1";
          level = 5;
          facility = "Test";
        }
      );

      passwordSecret = "YGhZ59wXMrYOojx5xdgEpBpDw2N6FbhM4lTtaJ1KPxxmKrUvSlDbtWArwAWMQ5LKx1ojHEVrQrBMVRdXbRyZLqffoUzHfssc";
      # `echo -n "nixos" | shasum -a 256`
      rootPasswordSha2 = "6ed332bcfa615381511d4d5ba44a293bb476f368f7e9e304f0dff50230d1a85b";
    in
    ''
      machine.start()
      machine.execute("echo \"${passwordSecret}\" > /run/graylog-passwordsecret && chmod 400 /run/checkmate-passwordsecret")
      machine.execute("echo \"${rootPasswordSha2}\" > /run/graylog-rootpasswordsha2 && chmod 400 /run/checkmate-rootpasswordsha2")
      machine.wait_for_unit("graylog.service")

      machine.wait_until_succeeds(
        "journalctl -o cat -u graylog.service | grep 'Started REST API at <127.0.0.1:9000>'"
      )

      machine.wait_for_open_port(9000)
      machine.succeed("curl -sSfL http://127.0.0.1:9000/")

      machine.wait_until_succeeds(
        "journalctl -o cat -u graylog.service | grep 'Graylog server up and running'"
      )

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
        "journalctl -o cat -u graylog.service | grep -E 'Input \[GELF UDP/Demo/[[:alnum:]]{24}\] is now RUNNING'"
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
          + "-sSfL 'http://127.0.0.1:9000/api/search/universal/relative?query=*&range=300&fields=*' "
          + f"-u {session}:session "
          + "-H 'Accept: application/json' "
          + "-H 'Content-Type: application/json' "
          + "-H 'x-requested-by: cli'"
          + ' | jq \'.total_results\' | xargs echo)" = "1"'
      )

      machine.shutdown()
    '';
}
