{ lib, ... }:

let
  password = "s3cRe!p4SsW0rD";
in

{
  name = "lavalink";
  meta.maintainers = with lib.maintainers; [ nanoyaki ];

  nodes = {
    machine = {
      services.lavalink = {
        enable = true;
        port = 1234;
        inherit password;
      };
    };
    machine2 =
      { pkgs, ... }:
      {
        services.lavalink = {
          enable = true;
          port = 1235;
          environmentFile = "${pkgs.writeText "passwordEnvFile" ''
            LAVALINK_SERVER_PASSWORD=${password}
          ''}";
        };
      };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("lavalink.service")
    machine.wait_for_open_port(1234)
    machine.succeed("curl --header \"User-Id: 1204475253028429844\" --header \"Client-Name: shoukaku/4.1.1\" --header \"Authorization: ${password}\" http://localhost:1234/v4/info --fail -v")

    machine2.wait_for_unit("lavalink.service")
    machine2.wait_for_open_port(1235)
    machine2.succeed("curl --header \"User-Id: 1204475253028429844\" --header \"Client-Name: shoukaku/4.1.1\" --header \"Authorization: ${password}\" http://localhost:1235/v4/info --fail -v")
  '';
}
