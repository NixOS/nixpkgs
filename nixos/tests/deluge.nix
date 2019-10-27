import ./make-test.nix ({ pkgs, ...} : {
  name = "deluge";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ flokli ];
  };

  nodes = {
    simple = {
      services.deluge = {
        enable = true;
        web = {
          enable = true;
          openFirewall = true;
        };
      };
    };

    declarative =
      { ... }:

      {
        services.deluge = {
          enable = true;
          openFirewall = true;
          declarative = true;
          config = {
            allow_remote = true;
            download_location = "/var/lib/deluge/my-download";
            daemon_port = 58846;
            listen_ports = [ 6881 6889 ];
          };
          web = {
            enable = true;
            port =  3142;
          };
          authFile = pkgs.writeText "deluge-auth" ''
            localclient:a7bef72a890:10
            andrew:password:10
            user3:anotherpass:5
          '';
        };
        environment.systemPackages = [ pkgs.deluge ];
      };

  };

  testScript = ''
    startAll;

    $simple->waitForUnit("deluged");
    $simple->waitForUnit("delugeweb");
    $simple->waitForOpenPort("8112");
    $declarative->waitForUnit("network.target");
    $declarative->waitUntilSucceeds("curl --fail http://simple:8112");

    $declarative->waitForUnit("deluged");
    $declarative->waitForUnit("delugeweb");
    $declarative->waitUntilSucceeds("curl --fail http://declarative:3142");
    $declarative->succeed("deluge-console 'help' | grep -q 'rm - Remove a torrent'");
    $declarative->succeed("deluge-console 'connect 127.0.0.1:58846 andrew password; help' | grep -q 'rm - Remove a torrent'");
  '';
})
