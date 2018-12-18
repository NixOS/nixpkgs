import ./make-test.nix ({ pkgs, ... }: let

  eicarTestFile = pkgs.fetchurl {
    url = "http://2016.eicar.org/download/eicar.com.txt";
    sha256 = "03zxa7vap2jkqjif4bzcjp33yrnip5yrz2bisia9wj5npwdh4ni7";
  };

  clamavMain = builtins.fetchurl "http://database.clamav.net/main.cvd";
  clamavDaily = builtins.fetchurl "http://database.clamav.net/daily.cvd";
  clamavBytecode = builtins.fetchurl "http://database.clamav.net/bytecode.cvd";

in {
  name = "clamav";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ fpletz ];
  };

  nodes.machine = { ... }: {
    virtualisation.memorySize = 1024;

    services.clamav.daemon.enable = true;
    systemd.services.clamav-daemon.preStart = ''
      mkdir -p /var/lib/clamav
      ln -sf ${clamavMain} /var/lib/clamav/main.cvd
      ln -sf ${clamavDaily} /var/lib/clamav/daily.cvd
      ln -sf ${clamavBytecode} /var/lib/clamav/bytecode.cvd
    '';
  };

  testScript = ''
    startAll;
    $machine->waitForUnit("multi-user.target");
    $machine->waitForUnit("clamav-daemon.service");
    $machine->waitForFile("/run/clamav/clamd.ctl");
    $machine->fail("clamdscan ${eicarTestFile}");
  '';
})
