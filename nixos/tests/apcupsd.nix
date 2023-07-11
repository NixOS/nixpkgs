let
  # arbitrary address
  ipAddr = "192.168.42.42";
in
import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "apcupsd";
  meta.maintainers = with lib.maintainers; [ bjornfor ];

  nodes = {
    machine = {
      services.apcupsd = {
        enable = true;
        configText = ''
          UPSTYPE usb
          BATTERYLEVEL 42
          # Configure NISIP so that the only way apcaccess can work is to read
          # this config.
          NISIP ${ipAddr}
        '';
      };
      networking.interfaces.eth1 = {
        ipv4.addresses = [{
          address = ipAddr;
          prefixLength = 24;
        }];
      };
    };
  };

  # Check that the service starts, that the CLI (apcaccess) works and that it
  # uses the config (ipAddr) defined in the service config.
  testScript = ''
    start_all()
    machine.wait_for_unit("apcupsd.service")
    machine.wait_for_open_port(3551, "${ipAddr}")
    res = machine.succeed("apcaccess")
    expect_line="MBATTCHG : 42 Percent"
    assert "MBATTCHG : 42 Percent" in res, f"expected apcaccess output to contain '{expect_line}' but got '{res}'"
    machine.shutdown()
  '';
})
