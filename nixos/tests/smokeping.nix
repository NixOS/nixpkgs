import ./make-test-python.nix ({ pkgs, ...} : {
  name = "smokeping";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ cransom ];
  };

  nodes = {
    sm =
      { ... }:
      {
        networking.domain = "example.com"; # FQDN: sm.example.com
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
    start_all()
    sm.wait_for_unit("smokeping")
    sm.wait_for_unit("thttpd")
    sm.wait_for_file("/var/lib/smokeping/data/Local/LocalMachine.rrd")
    sm.succeed("curl -s -f localhost:8081/smokeping.fcgi?target=Local")
    # Check that there's a helpful page without explicit path as well.
    sm.succeed("curl -s -f localhost:8081")
    sm.succeed("ls /var/lib/smokeping/cache/Local/LocalMachine_mini.png")
    sm.succeed("ls /var/lib/smokeping/cache/index.html")
  '';
})
