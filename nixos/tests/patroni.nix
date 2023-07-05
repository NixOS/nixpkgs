import ./make-test-python.nix ({ pkgs, lib, ... }:

  let
    nodesIps = [
      "192.168.1.1"
      "192.168.1.2"
      "192.168.1.3"
    ];

    createNode = index: { pkgs, ... }:
      let
        ip = builtins.elemAt nodesIps index; # since we already use IPs to identify servers
      in
      {
        networking.interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
          { address = ip; prefixLength = 16; }
        ];

        networking.firewall.allowedTCPPorts = [ 5432 8008 5010 ];

        environment.systemPackages = [ pkgs.jq ];

        services.patroni = {

          enable = true;

          postgresqlPackage = pkgs.postgresql_14.withPackages (p: [ p.pg_safeupdate ]);

          scope = "cluster1";
          name = "node${toString(index + 1)}";
          nodeIp = ip;
          otherNodesIps = builtins.filter (h: h != ip) nodesIps;
          softwareWatchdog = true;

          settings = {
            bootstrap = {
              dcs = {
                ttl = 30;
                loop_wait = 10;
                retry_timeout = 10;
                maximum_lag_on_failover = 1048576;
              };
              initdb = [
                { encoding = "UTF8"; }
                "data-checksums"
              ];
            };

            postgresql = {
              use_pg_rewind = true;
              use_slots = true;
              authentication = {
                replication = {
                  username = "replicator";
                };
                superuser = {
                  username = "postgres";
                };
                rewind = {
                  username = "rewind";
                };
              };
              parameters = {
                listen_addresses = "${ip}";
                wal_level = "replica";
                hot_standby_feedback = "on";
                unix_socket_directories = "/tmp";
              };
              pg_hba = [
                "host replication replicator 192.168.1.0/24 md5"
                # Unsafe, do not use for anything other than tests
                "host all all 0.0.0.0/0 trust"
              ];
            };

            etcd3 = {
              host = "192.168.1.4:2379";
            };
          };

          environmentFiles = {
            PATRONI_REPLICATION_PASSWORD = pkgs.writeText "replication-password" "postgres";
            PATRONI_SUPERUSER_PASSWORD = pkgs.writeText "superuser-password" "postgres";
            PATRONI_REWIND_PASSWORD = pkgs.writeText "rewind-password" "postgres";
          };
        };

        # We always want to restart so the tests never hang
        systemd.services.patroni.serviceConfig.StartLimitIntervalSec = 0;
      };
  in
  {
    name = "patroni";

    nodes = {
      node1 = createNode 0;
      node2 = createNode 1;
      node3 = createNode 2;

      etcd = { pkgs, ... }: {

        networking.interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
          { address = "192.168.1.4"; prefixLength = 16; }
        ];

        services.etcd = {
          enable = true;
          listenClientUrls = [ "http://192.168.1.4:2379" ];
        };

        networking.firewall.allowedTCPPorts = [ 2379 ];
      };

      client = { pkgs, ... }: {
        environment.systemPackages = [ pkgs.postgresql_14 ];

        networking.interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
          { address = "192.168.2.1"; prefixLength = 16; }
        ];

        services.haproxy = {
          enable = true;
          config = ''
            global
                maxconn 100

            defaults
                log global
                mode tcp
                retries 2
                timeout client 30m
                timeout connect 4s
                timeout server 30m
                timeout check 5s

            listen cluster1
                bind 127.0.0.1:5432
                option httpchk
                http-check expect status 200
                default-server inter 3s fall 3 rise 2 on-marked-down shutdown-sessions
                ${builtins.concatStringsSep "\n" (map (ip: "server postgresql_${ip}_5432 ${ip}:5432 maxconn 100 check port 8008") nodesIps)}
          '';
        };
      };
    };



    testScript = ''
      nodes = [node1, node2, node3]

      def wait_for_all_nodes_ready(expected_replicas=2):
          booted_nodes = filter(lambda node: node.booted, nodes)
          for node in booted_nodes:
              print(node.succeed("patronictl list cluster1"))
              node.wait_until_succeeds(f"[ $(patronictl list -f json cluster1 | jq 'length') == {expected_replicas + 1} ]")
              node.wait_until_succeeds("[ $(patronictl list -f json cluster1 | jq 'map(select(.Role | test(\"^Leader$\"))) | map(select(.State | test(\"^running$\"))) | length') == 1 ]")
              node.wait_until_succeeds(f"[ $(patronictl list -f json cluster1 | jq 'map(select(.Role | test(\"^Replica$\"))) | map(select(.State | test(\"^running$\"))) | length') == {expected_replicas} ]")
              print(node.succeed("patronictl list cluster1"))
          client.wait_until_succeeds("psql -h 127.0.0.1 -U postgres --command='select 1;'")

      def run_dummy_queries():
          client.succeed("psql -h 127.0.0.1 -U postgres --pset='pager=off' --tuples-only --command='insert into dummy(val) values (101);'")
          client.succeed("test $(psql -h 127.0.0.1 -U postgres --pset='pager=off' --tuples-only --command='select val from dummy where val = 101;') -eq 101")
          client.succeed("psql -h 127.0.0.1 -U postgres --pset='pager=off' --tuples-only --command='delete from dummy where val = 101;'")

      start_all()

      etcd.wait_for_unit("etcd.service")

      with subtest("should bootstrap a new patroni cluster"):
          wait_for_all_nodes_ready()

      with subtest("should be able to insert and select"):
          client.succeed("psql -h 127.0.0.1 -U postgres --command='create table dummy as select * from generate_series(1, 100) as val;'")
          client.succeed("test $(psql -h 127.0.0.1 -U postgres --pset='pager=off' --tuples-only --command='select count(distinct val) from dummy;') -eq 100")

      with subtest("should restart after all nodes are crashed"):
          for node in nodes:
              node.crash()
          for node in nodes:
              node.start()
          wait_for_all_nodes_ready()

      with subtest("should be able to run queries while any one node is crashed"):
          masterNodeName = node1.succeed("patronictl list -f json cluster1 | jq '.[] | select(.Role | test(\"^Leader$\")) | .Member' -r").strip()
          masterNodeIndex = int(masterNodeName[len(masterNodeName)-1]) - 1

          # Move master node at the end of the list to avoid multiple failovers (makes the test faster and more consistent)
          nodes.append(nodes.pop(masterNodeIndex))

          for node in nodes:
              node.crash()
              wait_for_all_nodes_ready(1)

              # Execute some queries while a node is down.
              run_dummy_queries()

              # Restart crashed node.
              node.start()
              wait_for_all_nodes_ready()

              # Execute some queries with the node back up.
              run_dummy_queries()
    '';
  })
