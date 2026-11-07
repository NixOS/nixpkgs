{ ... }:
{
  name = "taskchampion-sync-server";

  nodes = {
    server = {
      services.taskchampion-sync-server.enable = true;
      services.taskchampion-sync-server.host = "0.0.0.0";
      services.taskchampion-sync-server.openFirewall = true;
    };
    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.taskwarrior3 ];
      };
  };
  testScript =
    { nodes, ... }:
    let
      cfg = nodes.server.services.taskchampion-sync-server;
      port = toString cfg.port;
      # Generated with uuidgen
      uuid = "bf01376e-04a4-435a-9263-608567531af3";
      password = "nixos-test";
    in
    ''
      # Explicitly start the VMs so that we don't accidentally start newServer
      server.start()
      client.start()

      server.wait_for_unit("taskchampion-sync-server.service")
      server.wait_for_open_port(${port})

      # See man task-sync(5)
      client.succeed("mkdir ~/.task")
      client.succeed("touch ~/.taskrc")
      client.succeed("echo sync.server.origin=http://server:${port} >> ~/.taskrc")
      client.succeed("echo sync.server.client_id=${uuid} >> ~/.taskrc")
      client.succeed("echo sync.encryption_secret=${password} >> ~/.taskrc")
      client.succeed("task add hello world")
      client.succeed("task sync")

      # Useful for debugging
      client.copy_from_machine("/root/.task", "client")
      server.copy_from_machine(
          # Ever since DynamicUser defaults to true[1], dataDir is a symlink
          # into /var/lib/private, and symlink resolving is needed.
          #
          # [1]: https://github.com/NixOS/nixpkgs/commit/95fc26d18a19207b20acfee182db120efc36d1d3
          server.succeed("readlink -f ${cfg.dataDir}").strip(),
          "server",
      )
    '';
}
