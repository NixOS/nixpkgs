import ./make-test.nix ({ pkgs, ...} : {
  name = "smokeping";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ cransom ];
  };

  nodes = {
    sm =
      { ... }:
      {
        services.smokeping = {
          enable = true;
          port = 8081;
          mailHost = "127.0.0.2";
          probeConfig = ''
            + FPing
            binary = /run/wrappers/bin/fping
            offset = 0%
          '';
        };
      };
  };

  testScript = ''
    startAll;
    $sm->waitForUnit("smokeping");
    $sm->waitForUnit("thttpd");
    $sm->waitForFile("/var/lib/smokeping/data/Local/LocalMachine.rrd");
    $sm->succeed("curl -s -f localhost:8081/smokeping.fcgi?target=Local");
    $sm->succeed("ls /var/lib/smokeping/cache/Local/LocalMachine_mini.png");
    $sm->succeed("ls /var/lib/smokeping/cache/index.html");
  '';
})
