import ./make-test-python.nix (
  { ... }:
  {
    name = "taskchampion-sync-server";

    nodes = {
      server = {
        services.taskchampion-sync-server.enable = true;
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
        port = builtins.toString cfg.port;
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
        client.copy_from_vm("/root/.task", "client")
        server.copy_from_vm("${cfg.dataDir}", "server")
      '';
  }
)
