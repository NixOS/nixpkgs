import ./make-test-python.nix ({ pkgs, ... }:
let
  redisSocket = "/run/redis/redis.sock";
in
{
  name = "redis";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ flokli ];
  };

  nodes = {
    machine =
      { pkgs, ... }:

      {
        services.redis.enable = true;
        services.redis.unixSocket = redisSocket;

        # Allow access to the unix socket for the "redis" group.
        services.redis.unixSocketPerm = 770;

        users.users."member" = {
          createHome = false;
          description = "A member of the redis group";
          isNormalUser = true;
          extraGroups = [
            "redis"
          ];
        };
      };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("redis")
    machine.wait_for_open_port("6379")

    # The unix socket is accessible to the redis group
    machine.succeed('su member -c "redis-cli ping | grep PONG"')

    machine.succeed("redis-cli ping | grep PONG")
    machine.succeed("redis-cli -s ${redisSocket} ping | grep PONG")
  '';
})
