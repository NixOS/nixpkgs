# integration tests for saned/sane-net functionality
# saned is a daemon which provides remote-access to scanners
# sane-net is a sane backend, which connects to remote saned instances
let
  serverAddress = "192.168.1.1";
  clientAddress = "192.168.1.2";
in
import ./make-test-python.nix ({ pkgs, ...} : {
  name = "saned-sane-net";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ eliasp ];
  };

  nodes.server = { pkgs, lib, ... }:
    {
      networking.interfaces.eth1.ipv4.addresses = lib.mkForce [{
        address = serverAddress;
        prefixLength = 24;
      }];
      hardware.sane = {
        enable = true;
        enabledDefaultBackends = ["test"];
      };
      services.saned = {
        enable = true;
        openFirewall = true;
      };
    };
  nodes.client = { pkgs, lib, ... }:
    {
      networking.interfaces.eth1.ipv4.addresses = lib.mkForce [{
        address = clientAddress;
        prefixLength = 24;
      }];
      hardware.sane = {
        enable = true;
        enabledDefaultBackends = ["test" "net"];
        remoteHosts = [serverAddress];
      };
    };

  testScript = ''
    start_all()
    server.wait_for_unit("saned.socket")
    client.wait_for_unit("network.target")
    # scanimage lists two test scanners
    deviceList = client.succeed('scanimage -p -L')
    assert "device `test:0' is a Noname frontend-tester virtual device" in deviceList
    assert "device `test:1' is a Noname frontend-tester virtual device" in deviceList

    # scanimage lists two remote test scanners
    assert "device `net:${serverAddress}:test:0' is a Noname frontend-tester virtual device" in deviceList
    assert "device `net:${serverAddress}:test:1' is a Noname frontend-tester virtual device" in deviceList

    server.block()
    deviceList = client.succeed('scanimage -p -L')

    # scanimage doesn't list two remote test scanners
    assert "device `net:${serverAddress}:test:0' is a Noname frontend-tester virtual device" not in deviceList
    assert "device `net:${serverAddress}:test:1' is a Noname frontend-tester virtual device" not in deviceList
  '';
})
