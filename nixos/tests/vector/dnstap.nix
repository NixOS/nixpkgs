import ../make-test-python.nix (
  { lib, pkgs, ... }:

  let
    dnstapSocket = "/var/run/vector/dnstap.sock";
  in
  {
    name = "vector-dnstap";
    meta.maintainers = [ pkgs.lib.maintainers.happysalada ];

    nodes = {
      unbound =
        { config, pkgs, ... }:
        {
          networking.firewall.allowedUDPPorts = [ 53 ];

          services.vector = {
            enable = true;

            settings = {
              sources = {
                dnstap = {
                  type = "dnstap";
                  multithreaded = true;
                  mode = "unix";
                  lowercase_hostnames = true;
                  socket_file_mode = 504;
                  socket_path = "${dnstapSocket}";
                };
              };

              sinks = {
                file = {
                  type = "file";
                  inputs = [ "dnstap" ];
                  path = "/var/lib/vector/logs.log";
                  encoding = {
                    codec = "json";
                  };
                };
              };
            };
          };

          systemd.services.vector.serviceConfig = {
            RuntimeDirectory = "vector";
            RuntimeDirectoryMode = "0770";
          };

          services.unbound = {
            enable = true;
            enableRootTrustAnchor = false;
            package = pkgs.unbound-full;
            settings = {
              server = {
                interface = [
                  "0.0.0.0"
                  "::"
                ];
                access-control = [
                  "192.168.0.0/24 allow"
                  "::/0 allow"
                ];

                domain-insecure = "local";
                private-domain = "local";

                local-zone = "local. static";
                local-data = [
                  ''"test.local. 10800 IN A 192.168.123.5"''
                ];
              };

              dnstap = {
                dnstap-enable = "yes";
                dnstap-socket-path = "${dnstapSocket}";
                dnstap-send-identity = "yes";
                dnstap-send-version = "yes";
                dnstap-log-client-query-messages = "yes";
                dnstap-log-client-response-messages = "yes";
              };
            };
          };

          systemd.services.unbound = {
            after = [ "vector.service" ];
            wants = [ "vector.service" ];
            serviceConfig = {
              # DNSTAP access
              ReadWritePaths = [ "/var/run/vector" ];
              SupplementaryGroups = [ "vector" ];
            };
          };
        };

      dnsclient =
        { config, pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.dig ];
        };
    };

    testScript = ''
      unbound.wait_for_unit("unbound")
      unbound.wait_for_unit("vector")

      unbound.wait_until_succeeds(
        "journalctl -o cat -u vector.service | grep 'Socket permissions updated to 0o770'"
      )
      unbound.wait_until_succeeds(
        "journalctl -o cat -u vector.service | grep 'component_type=dnstap' | grep 'Listening... path=\"${dnstapSocket}\"'"
      )

      unbound.wait_for_file("${dnstapSocket}")
      unbound.succeed("test 770 -eq $(stat -c '%a' ${dnstapSocket})")

      dnsclient.wait_for_unit("network-online.target")
      dnsclient.succeed(
        "dig @unbound test.local"
      )

      unbound.wait_for_file("/var/lib/vector/logs.log")

      unbound.wait_until_succeeds(
        "grep ClientQuery /var/lib/vector/logs.log | grep '\"domainName\":\"test.local.\"' | grep '\"rcodeName\":\"NoError\"'"
      )
      unbound.wait_until_succeeds(
        "grep ClientResponse /var/lib/vector/logs.log | grep '\"domainName\":\"test.local.\"' | grep '\"rData\":\"192.168.123.5\"'"
      )
    '';
  }
)
