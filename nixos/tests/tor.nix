import ./make-test.nix ({ lib, ... }: with lib;

rec {
  name = "tor";
  meta.maintainers = with maintainers; [ joachifm ];

  common =
    { ... }:
    { boot.kernelParams = [ "audit=0" "apparmor=0" "quiet" ];
      networking.firewall.enable = false;
      networking.useDHCP = false;
    };

  nodes.client =
    { pkgs, ... }:
    { imports = [ common ];
      environment.systemPackages = with pkgs; [ netcat ];
      services.tor.enable = true;
      services.tor.client.enable = true;
      services.tor.controlPort = 9051;
    };

  testScript = ''
    $client->waitForUnit("tor.service");
    $client->waitForOpenPort(9051);
    $client->succeed("echo GETINFO version | nc 127.0.0.1 9051") =~ /514 Authentication required./ or die;
  '';
})
