{ pkgs, ... }:
{
  name = "deluge";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ flokli ];
  };

  nodes = {
    simple = {
      services.deluge = {
        enable = true;
        package = pkgs.deluge-2_x;
        web = {
          enable = true;
          openFirewall = true;
        };
      };
    };

    declarative = {
      services.deluge = {
        enable = true;
        package = pkgs.deluge-2_x;
        openFirewall = true;
        declarative = true;
        config = {
          allow_remote = true;
          download_location = "/var/lib/deluge/my-download";
          daemon_port = 58846;
          listen_ports = [
            6881
            6889
          ];
        };
        web = {
          enable = true;
          port = 3142;
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

    simple.wait_for_unit("deluged")
    simple.wait_for_unit("delugeweb")
    simple.wait_for_open_port(8112)
    declarative.wait_for_unit("network.target")
    declarative.wait_until_succeeds("curl --fail http://simple:8112")

    declarative.wait_for_unit("deluged")
    declarative.wait_for_unit("delugeweb")
    declarative.wait_until_succeeds("curl --fail http://declarative:3142")

    # deluge-console always exits with 1. https://dev.deluge-torrent.org/ticket/3291
    declarative.succeed(
        "(deluge-console 'connect 127.0.0.1:58846 andrew password; help' || true) | grep -q 'rm.*Remove a torrent'"
    )
  '';
}
