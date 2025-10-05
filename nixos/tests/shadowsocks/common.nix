{
  name,
  plugin ? null,
  pluginOpts ? "",
}:

import ../make-test-python.nix (
  { pkgs, lib, ... }:
  {
    inherit name;
    meta = {
      maintainers = with lib.maintainers; [ hmenke ];
    };

    nodes = {
      server = {
        boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
        networking.useDHCP = false;
        networking.interfaces.eth1.ipv4.addresses = [
          {
            address = "192.168.0.1";
            prefixLength = 24;
          }
        ];
        networking.firewall.rejectPackets = true;
        networking.firewall.allowedTCPPorts = [ 8488 ];
        networking.firewall.allowedUDPPorts = [ 8488 ];
        services.shadowsocks = {
          enable = true;
          encryptionMethod = "chacha20-ietf-poly1305";
          password = "pa$$w0rd";
          localAddress = [ "0.0.0.0" ];
          port = 8488;
          fastOpen = false;
          mode = "tcp_and_udp";
        }
        // lib.optionalAttrs (plugin != null) {
          inherit plugin;
          pluginOpts = "server;${pluginOpts}";
        };
        services.nginx = {
          enable = true;
          virtualHosts.server = {
            locations."/".root = pkgs.writeTextDir "index.html" "It works!";
          };
        };
      };

      client = {
        networking.useDHCP = false;
        networking.interfaces.eth1.ipv4.addresses = [
          {
            address = "192.168.0.2";
            prefixLength = 24;
          }
        ];
        systemd.services.shadowsocks-client = {
          description = "connect to shadowsocks";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          path = with pkgs; [ shadowsocks-libev ];
          script = ''
            exec ss-local \
                -s 192.168.0.1 \
                -p 8488 \
                -l 1080 \
                -k 'pa$$w0rd' \
                -m chacha20-ietf-poly1305 \
                -a nobody \
                ${lib.optionalString (plugin != null) ''
                  --plugin "${plugin}" --plugin-opts "${pluginOpts}"
                ''}
          '';
        };
      };
    };

    testScript = ''
      start_all()

      server.wait_for_unit("shadowsocks-libev.service")
      server.wait_for_unit("nginx.service")
      client.wait_for_unit("shadowsocks-client.service")

      client.fail(
          "${pkgs.curl}/bin/curl 192.168.0.1:80"
      )

      msg = client.succeed(
          "${pkgs.curl}/bin/curl --socks5 localhost:1080 192.168.0.1:80"
      )
      assert msg == "It works!", "Could not connect through shadowsocks"
    '';
  }
)
