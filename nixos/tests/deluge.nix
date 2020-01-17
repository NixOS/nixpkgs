import ./make-test-python.nix ({ pkgs, ...} : {
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
    start_all()

    simple.wait_for_unit("deluged")
    simple.wait_for_unit("delugeweb")
    simple.wait_for_open_port("8112")
    declarative.wait_for_unit("network.target")
    declarative.wait_until_succeeds("curl --fail http://simple:8112")

    declarative.wait_for_unit("deluged")
    declarative.wait_for_unit("delugeweb")
    declarative.wait_until_succeeds("curl --fail http://declarative:3142")
    declarative.succeed("deluge-console 'help' | grep -q 'rm - Remove a torrent'")
    declarative.succeed(
        "deluge-console 'connect 127.0.0.1:58846 andrew password; help' | grep -q 'rm - Remove a torrent'"
    )
  '';
})
