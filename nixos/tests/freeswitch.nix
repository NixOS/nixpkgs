import ./make-test-python.nix ({ pkgs, ...} : {
  name = "freeswitch";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ misuzu ];
  };
  nodes = {
    node0 = { config, lib, ... }: {
      networking.useDHCP = false;
      networking.interfaces.eth1 = {
        ipv4.addresses = [
          {
            address = "192.168.0.1";
            prefixLength = 24;
          }
        ];
      };
      services.freeswitch = {
        enable = true;
        enableReload = true;
        configTemplate = "${config.services.freeswitch.package}/share/freeswitch/conf/minimal";
      };
    };
  };
  testScript = ''
    node0.wait_for_unit("freeswitch.service")
    # Wait for SIP port to be open
    node0.wait_for_open_port(5060)
  '';
})
