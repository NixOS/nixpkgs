import ./make-test-python.nix ({ pkgs, lib, ... }:
{
  name = "redis";
  meta.maintainers = with lib.maintainers; [ flokli ];

  nodes = {
    machine =
      { pkgs, lib, ... }:

      {
        services.redis.servers."".enable = true;
        services.redis.servers."test".enable = true;

        users.users = lib.listToAttrs (map (suffix: lib.nameValuePair "member${suffix}" {
          createHome = false;
          description = "A member of the redis${suffix} group";
          isNormalUser = true;
          extraGroups = [ "redis${suffix}" ];
        }) ["" "-test"]);
      };
  };

  testScript = { nodes, ... }: let
    inherit (nodes.machine.config.services) redis;
    in ''
    start_all()
    machine.wait_for_unit("redis")
    machine.wait_for_unit("redis-test")

    # The unnamed Redis server still opens a port for backward-compatibility
    machine.wait_for_open_port(6379)

    machine.wait_for_file("${redis.servers."".unixSocket}")
    machine.wait_for_file("${redis.servers."test".unixSocket}")

    # The unix socket is accessible to the redis group
    machine.succeed('su member -c "redis-cli ping | grep PONG"')
    machine.succeed('su member-test -c "redis-cli ping | grep PONG"')

    machine.succeed("redis-cli ping | grep PONG")
    machine.succeed("redis-cli -s ${redis.servers."".unixSocket} ping | grep PONG")
    machine.succeed("redis-cli -s ${redis.servers."test".unixSocket} ping | grep PONG")
  '';
})
