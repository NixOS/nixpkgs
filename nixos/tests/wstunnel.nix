let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in

{
  name = "wstunnel";

  nodes = {
    server = {
      virtualisation.vlans = [ 1 ];

      security.pki.certificateFiles = [ certs.ca.cert ];

      networking = {
        useNetworkd = true;
        useDHCP = false;
        firewall.enable = false;
      };

      systemd.network.networks."01-eth1" = {
        name = "eth1";
        networkConfig.Address = "10.0.0.1/24";
      };

      services.wstunnel = {
        enable = true;
        servers.my-server = {
          listen = {
            host = "10.0.0.1";
            port = 443;
          };
          settings = {
            tls-certificate = "${certs.${domain}.cert}";
            tls-private-key = "${certs.${domain}.key}";
          };
        };
      };
    };

    client = {
      virtualisation.vlans = [ 1 ];

      security.pki.certificateFiles = [ certs.ca.cert ];

      networking = {
        useNetworkd = true;
        useDHCP = false;
        firewall.enable = false;
        hosts = {
          "10.0.0.1" = [ domain ];
        };
      };

      systemd.network.networks."01-eth1" = {
        name = "eth1";
        networkConfig.Address = "10.0.0.2/24";
      };

      services.wstunnel = {
        enable = true;
        clients.my-client = {
          autoStart = false;
          connectTo = "wss://${domain}:443";
          settings = {
            local-to-remote = [ "tcp://8080:localhost:2080" ];
            remote-to-local = [ "tcp://2081:localhost:8081" ];
          };
        };
      };
    };
  };

  testScript = # python
    ''
      start_all()
      server.wait_for_unit("wstunnel-server-my-server.service")
      client.wait_for_open_port(443, "10.0.0.1")

      client.systemctl("start wstunnel-client-my-client.service")
      client.wait_for_unit("wstunnel-client-my-client.service")

      with subtest("connection from client to server"):
        server.succeed("nc -l 2080 >/tmp/msg &")
        client.sleep(1)
        client.succeed('nc -w1 localhost 8080 <<<"Hello from client"')
        server.succeed('grep "Hello from client" /tmp/msg')

      with subtest("connection from server to client"):
        client.succeed("nc -l 8081 >/tmp/msg &")
        server.sleep(1)
        server.succeed('nc -w1 localhost 2081 <<<"Hello from server"')
        client.succeed('grep "Hello from server" /tmp/msg')

      client.systemctl("stop wstunnel-client-my-client.service")
    '';
}
