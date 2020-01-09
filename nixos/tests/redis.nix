import ./make-test-python.nix ({ pkgs, ...} : {
  name = "redis";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ flokli ];
  };

  nodes = {
    machine =
      { pkgs, ... }:

      {
        services.redis.enable = true;
        services.redis.unixSocket = "/run/redis/redis.sock";
      };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("redis")
    machine.wait_for_open_port("6379")
    machine.succeed("redis-cli ping | grep PONG")
    machine.succeed("redis-cli -s /run/redis/redis.sock ping | grep PONG")
  '';
})
