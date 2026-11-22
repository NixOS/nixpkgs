{ pkgs, ... }:
let
  port = 50001;
in
{
  name = "rtorrent";
  meta = {
    maintainers = with pkgs.lib.maintainers; [ thiagokokada ];
  };

  nodes.machine =
    { ... }:
    {
      services.rtorrent = {
        inherit port;
        enable = true;
      };
    };

  testScript = # python
    ''
      machine.start()
      machine.wait_for_unit("rtorrent.service")
      machine.wait_for_open_port(${toString port})

      machine.succeed("nc -z localhost ${toString port}")
      machine.wait_until_succeeds("test -S /run/rtorrent/rpc.sock")
      machine.succeed("test -f /var/lib/rtorrent/session/rtorrent.lock")
      machine.succeed("test -d /var/lib/rtorrent/download")
      machine.succeed("test -n \"$(find /var/lib/rtorrent/log -name '*.log' -print -quit)\"")

      # Reuse the existing session directory and recreate the RPC socket on restart.
      machine.succeed("systemctl restart rtorrent.service")
      machine.wait_for_open_port(${toString port})
      machine.wait_until_succeeds("test -S /run/rtorrent/rpc.sock")
      machine.succeed("test -f /var/lib/rtorrent/session/rtorrent.lock")
    '';
}
