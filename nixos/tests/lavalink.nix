import ./make-test-python.nix (
  { pkgs, ... }:

  {
    name = "lavalink";
    meta.maintainers = with pkgs.lib.maintainers; [ nanoyaki ];

    nodes.machine = {
      services.lavalink = {
        enable = true;
        port = 1234;
        password = "s3cRe!p4SsW0rD";
      };
    };

    testScript = ''
      start_all()

      machine.wait_for_unit("lavalink.service")
      machine.wait_for_open_port(1234)
      machine.succeed("curl --header \"User-Id: 1204475253028429844\" --header \"Client-Name: shoukaku/4.1.1\" --header \"Authorization: s3cRe!p4SsW0rD\" http://localhost:1234/v4/info --fail -v")
    '';
  }
)
