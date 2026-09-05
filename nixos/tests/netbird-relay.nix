{ pkgs, lib, ... }:
{
  name = "netbird-relay";

  meta.maintainers = with pkgs.lib.maintainers; [
    woile
  ];

  nodes = {
    relay = {
      networking.hosts = {
        "127.0.0.1" = [ "relay.example.com" ];
      };
      systemd.tmpfiles.rules = [
        "d /run/ 0755 root root -"
        "f /run/auth_secret 0600 root root - super-secret-token"
      ];
      services.netbird.relay = {
        enable = true;
        settings = {
          listen-address = ":33080";
          # rel -> http ; rels -> https
          exposed-address = "rel://relay.example.com:33080";
          log-level = "info";
          enable-stun = true;
          stun-ports = [ 3479 ];
          health-listen-address = ":9000";
        };
        authSecretFile = "/run/auth_secret";
      };
    };
  };

  testScript = ''
    # Wait for service to start
    relay.start()
    relay.wait_for_unit("netbird-relay.service")

    # Wait for ports to be open an active
    relay.wait_for_open_port(9000)
    relay.wait_for_open_port(33080)

    # assert on health
    relay.succeed("curl -f http://127.0.0.1:9000/health")
  '';
}
