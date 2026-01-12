{ pkgs, runTest }:

let

  inherit (pkgs) lib;

  baseConfig = {
    networking.nameservers = [ "::1" ];
    services.bind = {
      enable = true;
      extraOptions = "empty-zones-enable no;";
      zones = lib.singleton {
        name = ".";
        master = true;
        file = pkgs.writeText "root.zone" ''
          $TTL 3600
          . IN SOA ns.example.org. admin.example.org. ( 1 3h 1h 1w 1d )
          . IN NS ns.example.org.

          ns.example.org. IN A    192.168.0.1
          ns.example.org. IN AAAA abcd::1

          1.0.168.192.in-addr.arpa IN PTR ns.example.org.
        '';
      };
    };
    services.dnsdist = {
      enable = true;
      listenPort = 5353;
      extraConfig = ''
        newServer({address="127.0.0.1:53", name="local-bind"})
      '';
    };
  };

in

{

  base = runTest {
    name = "dnsdist-base";
    meta.maintainers = with lib.maintainers; [ jojosch ];

    nodes.machine = baseConfig;

    testScript = ''
      machine.wait_for_unit("bind.service")
      machine.wait_for_open_port(53)
      machine.succeed("host -p 53 192.168.0.1 | grep -qF ns.example.org")

      machine.wait_for_unit("dnsdist.service")
      machine.wait_for_open_port(5353)
      machine.succeed("host -p 5353 192.168.0.1 | grep -qF ns.example.org")
    '';
  };

  dnscrypt = runTest {
    name = "dnsdist-dnscrypt";
    meta.maintainers = with lib.maintainers; [ rnhmjoj ];

    nodes.server = lib.mkMerge [
      baseConfig
      {
        networking.firewall.allowedTCPPorts = [ 443 ];
        networking.firewall.allowedUDPPorts = [ 443 ];
        services.dnsdist.dnscrypt.enable = true;
        services.dnsdist.dnscrypt.providerKey = pkgs.runCommand "dnscrypt-secret.key" { } ''
          echo 'R70+xqm7AaDsPtDgpSjSG7KHvEqVf6u6PZ+E3cGPbOwUQdg6/
                RIIpK6pHkINhrv7nxwIG5c7b/m5NJVT3A1AXQ==' | base64 -id > "$out"
        '';
      }
    ];

    nodes.client = {
      services.dnscrypt-proxy.enable = true;
      services.dnscrypt-proxy.upstreamDefaults = false;
      services.dnscrypt-proxy.settings = {
        server_names = [ "server" ];
        listen_addresses = [ "[::1]:53" ];
        cache = false;
        # Computed using https://dnscrypt.info/stamps/
        static.server.stamp = "sdns://AQAAAAAAAAAADzE5Mi4xNjguMS4yOjQ0MyAUQdg6_RIIpK6pHkINhrv7nxwIG5c7b_m5NJVT3A1AXRYyLmRuc2NyeXB0LWNlcnQuc2VydmVy";
      };
      networking.nameservers = [ "::1" ];
    };

    testScript = ''
      with subtest("The DNSCrypt server is accepting connections"):
          server.wait_for_unit("bind.service")
          server.wait_for_unit("dnsdist.service")
          server.wait_for_open_port(443)
          almost_expiration = server.succeed("date --date '14min'").strip()

      with subtest("The DNSCrypt client can connect to the server"):
          client.wait_until_succeeds("journalctl -u dnscrypt-proxy --grep '\\[server\\] OK'")

      with subtest("DNS queries over UDP are working"):
          client.wait_for_open_port(53)
          client.wait_until_succeeds("host -U 192.168.0.1", timeout=60)
          client.succeed("host -U 192.168.0.1 | grep -qF ns.example.org")

      with subtest("DNS queries over TCP are working"):
          client.wait_for_open_port(53)
          client.succeed("host -T 192.168.0.1 | grep -qF ns.example.org")

      with subtest("The server rotates the ephemeral keys"):
          server.succeed(f"date -s '{almost_expiration}'")
          client.succeed(f"date -s '{almost_expiration}'")
          server.wait_until_succeeds("journalctl -u dnsdist --grep 'rotated certificate'")

      with subtest("The client can still connect to the server"):
          client.wait_until_succeeds("host -T 192.168.0.1")
          client.wait_until_succeeds("host -U 192.168.0.1")
    '';
  };
}
