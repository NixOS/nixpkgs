# integration tests for brscan5 sane driver
#

import ./make-test-python.nix ({ pkgs, ...} : {
  name = "brscan5";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ mattchrist ];
  };

  machine = { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      hardware.sane = {
        enable = true;
        brscan5 = {
          enable = true;
          netDevices = {
            "a" = { model="MFC-7860DW"; nodename="BRW0080927AFBCE"; };
            "b" = { model="MFC-7860DW"; ip="192.168.1.2"; };
          };
        };
      };
    };

  testScript = ''
    # sane loads libsane-brother5.so.1 successfully, and scanimage doesn't die
    assert 'libsane-brother5.so.1", O_RDONLY|O_CLOEXEC) = 10' in machine.succeed('strace scanimage -L 2>&1')

    # module creates a config
    cfg = machine.succeed('cat /etc/opt/brother/scanner/brscan5/brsanenetdevice.cfg')
    assert 'DEVICE=a , "MFC-7860DW" , Unknown , NODENAME=BRW0080927AFBCE' in cfg
    assert 'DEVICE=b , "MFC-7860DW" , Unknown , IP-ADDRESS=192.168.1.2' in cfg
  '';
})
