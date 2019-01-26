import ../make-test.nix ({ pkgs, ... }:
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
      documentRoot = ./example;
      adminAddr = "noone@testing.nowhere";
    };
  };

  testScript =
    ''
      startAll;

      $machine->waitForUnit('multi-user.target');
      $machine->waitForUnit('hitch.service');
      $machine->waitForOpenPort(443);
      $machine->succeed('curl -k https://localhost:443/index.txt | grep "We are all good!"');
    '';
})
