{ lib, ... }:

let
  testPort = 8888;
  testUser = "testerman";
  testPass = "password";
  testEmail = "test.testerman@test.com";
in
{
  name = "atuin";
  meta.maintainers = with lib.maintainers; [ devusb ];

  defaults =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.atuin
      ];
    };

  nodes = {
    server =
      { ... }:
      {
        services.postgresql.enable = true;

        services.atuin = {
          enable = true;
          port = testPort;
          host = "0.0.0.0";
          openFirewall = true;
          openRegistration = true;
        };
      };

    client = { ... }: { };

  };

  testScript =
    { nodes, ... }:
    #python
    ''
      start_all()

      # wait for atuin server startup
      server.wait_for_unit("atuin.service")
      server.wait_for_open_port(${toString testPort})

      # configure atuin client on server node
      server.execute("mkdir -p ~/.config/atuin")
      server.execute("echo 'sync_address = \"http://localhost:${toString testPort}\"' > ~/.config/atuin/config.toml")

      # register with atuin server on server node
      server.succeed("atuin register -u ${testUser} -p ${testPass} -e ${testEmail}")
      _, key = server.execute("atuin key")

      # store test record in atuin server and sync
      server.succeed("ATUIN_SESSION=$(atuin uuid) atuin history start 'shazbot'")
      server.succeed("ATUIN_SESSION=$(atuin uuid) atuin sync")

      # configure atuin client on client node
      client.execute("mkdir -p ~/.config/atuin")
      client.execute("echo 'sync_address = \"http://server:${toString testPort}\"' > ~/.config/atuin/config.toml")

      # log in to atuin server on client node
      client.succeed(f"atuin login -u ${testUser} -p ${testPass} -k \"{key}\"")

      # pull records from atuin server
      client.succeed("atuin sync -f")

      # check for test record
      client.succeed("ATUIN_SESSION=$(atuin uuid) atuin history list | grep shazbot")
    '';
}
