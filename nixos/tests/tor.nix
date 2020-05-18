import ./make-test-python.nix ({ lib, ... }: with lib;

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
    client.wait_for_unit("tor.service")
    client.wait_for_open_port(9051)
    assert "514 Authentication required." in client.succeed(
        "echo GETINFO version | nc 127.0.0.1 9051"
    )
  '';
})
