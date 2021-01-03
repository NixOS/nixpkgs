import ./make-test-python.nix ({ pkgs, ... }:
let
  redisSocket = "/run/redis/redis.sock";
in
{
  name = "redis";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ flokli ];
  };

  nodes = {
    machine =
      { pkgs, ... }:

      {
        services.redis.enable = true;
        services.redis.unixSocket = redisSocket;
        services.redis.unixSocketPerm = 770;

        users.users."member" = {
          createHome = false;
          description = "Test user that is a member of the redis group";
          extraGroups = [
            "redis"
          ];
          group = "users";
          shell = "/bin/sh";
        };
      };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("redis")
    machine.wait_for_open_port("6379")

    # Test that the unix socket is accessible to the redis group
    machine.succeed(
        'perms="$(stat -c \'%a\' ${redisSocket})" && test "$perms" -eq 770'
    )
    machine.succeed(
        'owner="$(stat -c \'%U:%G\' ${redisSocket})" && test "$owner" = "redis:redis"'
    )
    machine.succeed('su member -c "redis-cli ping | grep PONG"')

    machine.succeed("redis-cli ping | grep PONG")
    machine.succeed("redis-cli -s ${redisSocket} ping | grep PONG")
  '';
})
