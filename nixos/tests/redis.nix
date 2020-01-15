import ./make-test.nix ({ pkgs, ...} : {
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
    startAll;

    $machine->waitForUnit("redis");
    $machine->waitForOpenPort("6379");

    $machine->succeed("redis-cli ping | grep PONG");
    $machine->succeed("redis-cli -s /run/redis/redis.sock ping | grep PONG");
  '';
})
