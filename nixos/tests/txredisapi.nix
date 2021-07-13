import ./make-test-python.nix ({ pkgs, ... }:
{
  name = "txredisapi";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ dandellion ];
  };

  nodes = {
    machine =
      { pkgs, ... }:

      {
        services.redis.enable = true;
        services.redis.unixSocket = "/run/redis/redis.sock";

        environment.systemPackages = with pkgs; [ (python38.withPackages (ps: [ ps.twisted ps.txredisapi ps.mock ]))];
      };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("redis")
    machine.wait_for_open_port("6379")

    tests = machine.succeed("PYTHONPATH=\"${pkgs.python3Packages.txredisapi.src}\" python -m twisted.trial ${pkgs.python3Packages.txredisapi.src}/tests")
  '';
})
