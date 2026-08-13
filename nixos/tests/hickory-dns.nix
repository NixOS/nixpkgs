{ pkgs, lib, ... }:

let
  cert = pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
    openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes \
      -subj '/CN=dns.example.local' \
      -addext 'subjectAltName = DNS:dns.example.local'
    mkdir -p $out
    cp key.pem cert.pem $out
  '';

  zoneFile = pkgs.writeText "example.local.zone" ''
    $TTL 3600
    @ IN SOA dns.example.local. admin.example.local. (
        1       ; Serial
        3600    ; Refresh
        1800    ; Retry
        604800  ; Expire
        3600    ; Minimum TTL
    )
              NS      dns.example.local.
    dns       A       192.168.0.2
    dns       AAAA    fd21::2
    example.local.    A       1.2.3.4
    example.local.    AAAA    abcd::eeff
  '';
in
{
  name = "hickory-dns";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      adamcstephens
      colinsane
    ];
  };

  nodes = {
    authoritative =
      { ... }:
      {
        networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
          {
            address = "192.168.0.1";
            prefixLength = 24;
          }
        ];
        networking.interfaces.eth1.ipv6.addresses = lib.mkForce [
          {
            address = "fd21::1";
            prefixLength = 64;
          }
        ];
        networking.firewall.allowedTCPPorts = [ 53 ];
        networking.firewall.allowedUDPPorts = [ 53 ];

        services.hickory-dns = {
          enable = true;
          settings = {
            listen_addrs_ipv4 = [ "0.0.0.0" ];
            listen_addrs_ipv6 = [ "::0" ];
            zones = [
              {
                zone = "example.local";
                zone_type = "Primary";
                file = toString zoneFile;
              }
            ];
          };
        };
      };

    forwarder =
      { ... }:
      {
        networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
          {
            address = "192.168.0.2";
            prefixLength = 24;
          }
        ];
        networking.interfaces.eth1.ipv6.addresses = lib.mkForce [
          {
            address = "fd21::2";
            prefixLength = 64;
          }
        ];
        networking.firewall.allowedTCPPorts = [
          53
          443 # DNS over HTTPS
          853 # DNS over TLS
        ];
        networking.firewall.allowedUDPPorts = [ 53 ];

        services.hickory-dns = {
          enable = true;
          settings = {
            listen_addrs_ipv4 = [ "0.0.0.0" ];
            listen_addrs_ipv6 = [ "::0" ];
            tls_listen_port = 853;
            https_listen_port = 443;
            tls_cert = {
              path = "${cert}/cert.pem";
              endpoint_name = "dns.example.local";
              private_key = "${cert}/key.pem";
            };
            zones = [
              {
                zone = "example.local";
                zone_type = "External";
                stores = {
                  type = "forward";
                  name_servers = [
                    {
                      ip = "192.168.0.1";
                      trust_negative_responses = false;
                      connections = [
                        {
                          protocol = {
                            type = "udp";
                          };
                        }
                        {
                          protocol = {
                            type = "tcp";
                          };
                        }
                      ];
                    }
                  ];
                };
              }
            ];
          };
        };
      };

    client =
      { lib, nodes, ... }:
      {
        environment.systemPackages = [
          pkgs.hickory-dns # resolve binary
          pkgs.knot-dns # kdig for DoT/DoH (resolve doesn't support TLS transports)
        ];
        networking.nameservers = [
          (lib.head nodes.forwarder.networking.interfaces.eth1.ipv6.addresses).address
          (lib.head nodes.forwarder.networking.interfaces.eth1.ipv4.addresses).address
        ];
        networking.interfaces.eth1.ipv4.addresses = [
          {
            address = "192.168.0.10";
            prefixLength = 24;
          }
        ];
        networking.interfaces.eth1.ipv6.addresses = [
          {
            address = "fd21::10";
            prefixLength = 64;
          }
        ];
        security.pki.certificateFiles = [ "${cert}/cert.pem" ];
        networking.hosts = {
          "192.168.0.2" = [ "dns.example.local" ];
          "fd21::2" = [ "dns.example.local" ];
        };
      };
  };

  testScript =
    { nodes, ... }:
    let
      forwarderIPv4 = (lib.head nodes.forwarder.networking.interfaces.eth1.ipv4.addresses).address;
      forwarderIPv6 = (lib.head nodes.forwarder.networking.interfaces.eth1.ipv6.addresses).address;
    in
    ''
      import typing

      zone = "example.local."
      records = [("AAAA", "abcd::eeff"), ("A", "1.2.3.4")]


      def resolve_query(
          machine,
          host: str,
          query_type: str,
          name: str,
          expected: typing.Optional[str] = None,
          tcp: bool = False,
      ):
          port = 53
          addr = f"[{host}]:{port}" if ":" in host else f"{host}:{port}"

          proto_flag = "--tcp" if tcp else "--udp"

          raw = machine.succeed(
              f"resolve -t {query_type} {proto_flag} --nameserver {addr} {name}"
          )

          answers = []
          in_answer = False

          for line in raw.splitlines():
              if ";; ANSWER SECTION:" in line:
                  in_answer = True
              elif in_answer and line.startswith(";; "):
                  break
              elif in_answer and line.startswith("\t"):
                  answers.append(line.split()[-1])

          out = "\n".join(answers)

          machine.log(f"{host} replied with {out}")

          if expected is not None:
              assert expected == out, f"Expected `{expected}` but got `{out}`"


      def kdig_query(
          machine,
          host: str,
          query_type: str,
          name: str,
          expected: typing.Optional[str] = None,
          args: typing.Optional[typing.List[str]] = None,
      ):
          text_args = " ".join(args or [])

          raw = machine.succeed(
              f"kdig {text_args} {name} {query_type} @{host} +short"
          ).strip()

          out = "\n".join(line for line in raw.splitlines() if not line.startswith(";;")).strip()

          machine.log(f"{host} replied with {out}")

          if expected is not None:
              assert expected == out, f"Expected `{expected}` but got `{out}`"


      def test(machine, remotes, zone=zone, records=records):
          for query_type, expected in records:
              for remote in remotes:
                  # Test UDP
                  resolve_query(machine, remote, query_type, zone, expected, tcp=False)
                  kdig_query(machine, remote, query_type, zone, expected)

                  # Test TCP
                  resolve_query(machine, remote, query_type, zone, expected, tcp=True)
                  kdig_query(machine, remote, query_type, zone, expected, ["+tcp"])

              # Test DoT/DoH
              kdig_query(machine, "dns.example.local", query_type, zone, expected, ["+tcp", "+tls"])
              kdig_query(machine, "dns.example.local", query_type, zone, expected, ["+https"])


      authoritative.wait_for_unit("hickory-dns.service")
      forwarder.wait_for_unit("hickory-dns.service")
      forwarder.wait_for_open_port(53)
      forwarder.wait_for_open_port(853)
      forwarder.wait_for_open_port(443)

      client.systemctl("start network-online.target")
      client.wait_for_unit("network-online.target")

      with subtest("forwarder resolves queries via authoritative nameserver"):
          test(
              client,
              ["${forwarderIPv6}", "${forwarderIPv4}"],
          )
    '';
}
