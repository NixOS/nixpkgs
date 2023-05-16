<<<<<<< HEAD
import ./make-test-python.nix ({ lib, ... }: {
  name = "tor";
  meta.maintainers = with lib.maintainers; [ joachifm ];
=======
import ./make-test-python.nix ({ lib, ... }: with lib;

{
  name = "tor";
  meta.maintainers = with maintainers; [ joachifm ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nodes.client = { pkgs, ... }: {
    boot.kernelParams = [ "audit=0" "apparmor=0" "quiet" ];
    networking.firewall.enable = false;
    networking.useDHCP = false;

<<<<<<< HEAD
    environment.systemPackages = [ pkgs.netcat ];
=======
    environment.systemPackages = with pkgs; [ netcat ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    services.tor.enable = true;
    services.tor.client.enable = true;
    services.tor.settings.ControlPort = 9051;
  };

  testScript = ''
    client.wait_for_unit("tor.service")
    client.wait_for_open_port(9051)
    assert "514 Authentication required." in client.succeed(
        "echo GETINFO version | nc 127.0.0.1 9051"
    )
  '';
})
