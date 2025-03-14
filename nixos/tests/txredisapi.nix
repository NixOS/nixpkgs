import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "txredisapi";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ dandellion ];
    };

    nodes = {
      machine =
        { pkgs, ... }:

        {
          services.redis.servers."".enable = true;

          environment.systemPackages = with pkgs; [
            (python3.withPackages (ps: [
              ps.twisted
              ps.txredisapi
              ps.mock
            ]))
          ];
        };
    };

    testScript =
      { nodes, ... }:
      let
        inherit (nodes.machine.config.services) redis;
      in
      ''
        start_all()
        machine.wait_for_unit("redis")
        machine.wait_for_file("${redis.servers."".unixSocket}")
        machine.succeed("ln -s ${redis.servers."".unixSocket} /tmp/redis.sock")

        tests = machine.succeed("PYTHONPATH=\"${pkgs.python3Packages.txredisapi.src}\" python -m twisted.trial ${pkgs.python3Packages.txredisapi.src}/tests")
      '';
  }
)
