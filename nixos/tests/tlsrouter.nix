{ lib, pkgs, ... }:

{
  name = "tlsrouter";

  meta.maintainers = with lib.maintainers; [ xsteadfastx ];

  nodes.node = {
    services = {
      caddy = {
        enable = true;
        configFile = pkgs.writeText "Caddyfile" ''
          {
            https_port 3000
          }

          foo.bar.tld {
            tls internal

            respond "hello world"
          }
        '';
      };

      tlsrouter = {
        enable = true;
        config = "foo.bar.tld 127.0.0.1:3000";
      };
    };
  };

  testScript = ''
    start_all()
    node.wait_for_unit("caddy")
    node.wait_for_open_port(3000)

    node.wait_for_unit("tlsrouter")
    node.wait_for_open_port(443)

    node.succeed("curl --fail -k --resolve foo.bar.tld:443:127.0.0.1 https://foo.bar.tld | grep hello")
  '';
}
