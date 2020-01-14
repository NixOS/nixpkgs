import ../make-test-python.nix ({ pkgs, ... }:
{
  name = "hitch";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ jflanglois ];
  };
  machine = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.curl ];
    services.hitch = {
      enable = true;
      backend = "[127.0.0.1]:80";
      pem-files = [
        ./example.pem
      ];
    };

    services.httpd = {
      enable = true;
      virtualHosts.localhost.documentRoot = ./example;
      adminAddr = "noone@testing.nowhere";
    };
  };

  testScript =
    ''
      start_all()

      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("hitch.service")
      machine.wait_for_open_port(443)
      assert "We are all good!" in machine.succeed("curl -k https://localhost:443/index.txt")
    '';
})
