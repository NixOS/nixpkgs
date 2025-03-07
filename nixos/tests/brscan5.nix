# integration tests for brscan5 sane driver
#

import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "brscan5";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ mattchrist ];
    };

    nodes.machine =
      { pkgs, ... }:
      {
        nixpkgs.config.allowUnfree = true;
        hardware.sane = {
          enable = true;
          brscan5 = {
            enable = true;
            netDevices = {
              "a" = {
                model = "ADS-1200";
                nodename = "BRW0080927AFBCE";
              };
              "b" = {
                model = "ADS-1200";
                ip = "192.168.1.2";
              };
            };
          };
        };
      };

    testScript = ''
      import re
      # sane loads libsane-brother5.so.1 successfully, and scanimage doesn't die
      strace = machine.succeed('strace scanimage -L 2>&1').split("\n")
      regexp = 'openat\(.*libsane-brother5.so.1", O_RDONLY|O_CLOEXEC\) = \d\d*$'
      assert len([x for x in strace if re.match(regexp,x)]) > 0

      # module creates a config
      cfg = machine.succeed('cat /etc/opt/brother/scanner/brscan5/brsanenetdevice.cfg')
      assert 'DEVICE=a , "ADS-1200" , 0x4f9:0x459 , NODENAME=BRW0080927AFBCE' in cfg
      assert 'DEVICE=b , "ADS-1200" , 0x4f9:0x459 , IP-ADDRESS=192.168.1.2' in cfg

      # scanimage lists the two network scanners
      scanimage = machine.succeed("scanimage -L")
      print(scanimage)
      assert """device `brother5:net1;dev0' is a Brother b ADS-1200""" in scanimage
      assert """device `brother5:net1;dev1' is a Brother a ADS-1200""" in scanimage
    '';
  }
)
