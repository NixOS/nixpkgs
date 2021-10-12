import ./make-test-python.nix ({ pkgs, ...} : {
  name = "deluge";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ flokli ];
  };

  nodes = {
    simple2 = {
      services.deluge = {
        enable = true;
        package = pkgs.deluge-2_x;
        web = {
          enable = true;
          openFirewall = true;
        };
      };
    };

    declarative2 = {
      services.deluge = {
        enable = true;
        package = pkgs.deluge-2_x;
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
    };

  };

  testScript = ''
    start_all()

    simple1.wait_for_unit("deluged")
    simple2.wait_for_unit("deluged")
    simple1.wait_for_unit("delugeweb")
    simple2.wait_for_unit("delugeweb")
    simple1.wait_for_open_port("8112")
    simple2.wait_for_open_port("8112")
    declarative1.wait_for_unit("network.target")
    declarative2.wait_for_unit("network.target")
    declarative1.wait_until_succeeds("curl --fail http://simple1:8112")
    declarative2.wait_until_succeeds("curl --fail http://simple2:8112")

    declarative1.wait_for_unit("deluged")
    declarative2.wait_for_unit("deluged")
    declarative1.wait_for_unit("delugeweb")
    declarative2.wait_for_unit("delugeweb")
    declarative1.wait_until_succeeds("curl --fail http://declarative1:3142")
    declarative2.wait_until_succeeds("curl --fail http://declarative2:3142")
    declarative1.succeed(
        "deluge-console 'connect 127.0.0.1:58846 andrew password; help' | grep -q 'rm.*Remove a torrent'"
    )
    declarative2.succeed(
        "deluge-console 'connect 127.0.0.1:58846 andrew password; help' | grep -q 'rm.*Remove a torrent'"
    )
  '';
})
