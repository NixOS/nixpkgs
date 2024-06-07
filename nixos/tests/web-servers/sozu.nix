import ../make-test-python.nix ({ lib, pkgs, ... }:

{
  name = "sozu";
  meta.maintainers = with pkgs.lib.maintainers; [ Br1ght0ne gaelreyrol ];

  nodes = {
    backend = { config, pkgs, ... }: {
      networking.firewall.allowedTCPPorts = [ 8080 ];

      networking.interfaces.eth1.ipv6.addresses = lib.mkForce [
        { address = "fd21::1"; prefixLength = 64; }
      ];

      services.static-web-server = {
        enable = true;
        listen = "[::]:8080";
        root = toString (pkgs.writeTextDir "nixos-test.html" ''
          <h1>Hello NixOS!</h1>
        '');
        configuration = {
          general = { directory-listing = true; };
        };
      };
    };

    sozu = { config, pkgs, ... }: {
      networking.firewall.allowedTCPPorts = [ 80 ];

      networking.interfaces.eth1.ipv6.addresses = lib.mkForce [
        { address = "fd21::2"; prefixLength = 64; }
      ];

      services.sozu = {
        enable = true;
        settings = {
          clusters = {
            "TestCluster" = {
              protocol = "http";

              frontends = [
                {
                  address = "[::]:80";
                  hostname = "sozu";
                }
              ];

              backends = [
                { address = "[fd21::1]:8080"; }
              ];
            };
           };
          listeners = [
            {
              protocol = "http";
              address = "[::]:80";
            }
          ];
        };
      };
    };

    client = { config, pkgs, ... }: { };
  };

  testScript =
  ''
    backend.wait_for_unit("static-web-server.socket")
    backend.wait_for_open_port(8080)

    sozu.wait_for_unit("sozu")
    sozu.wait_for_open_port(80)
    sozu.wait_for_file("/run/sozu/sozu.pid")

    sozu.wait_until_succeeds(
      "journalctl -o cat -u sozu.service | grep 'Successfully loaded the config'"
    )

    response = client.wait_until_succeeds(
      "curl -sSf http://sozu/nixos-test.html"
    )
    assert "Hello NixOS!" in response

    sozu.wait_until_succeeds(
      "journalctl -o cat -u sozu.service | grep 'HTTP sozu GET /nixos-test.html 200'"
    )

    sozu.log(sozu.succeed(
      "systemd-analyze security sozu.service | grep -v '✓'"
    ))
  '';
})
