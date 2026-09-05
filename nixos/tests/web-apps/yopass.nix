{
  runTest,
  pkgs,
  ...
}:

let
  inherit (pkgs) lib;
  yopassCli = lib.getExe pkgs.yopass;

  yopassTest =
    { name, backend }:
    runTest {
      name = "yopass-${name}";

      nodes.machine =
        { ... }:
        {
          services.memcached.enable = backend == "memcached";
          services.redis.servers.yopass = lib.mkIf (backend == "redis") {
            enable = true;
            # Named instances default to port 0 (Unix socket only); yopass
            # connects over TCP via a redis:// URL, so this needs enabling.
            port = 6379;
          };

          services.yopass = {
            enable = true;
            database.backend = backend;
            # "localhost" resolves to the IPv6 loopback first in this VM,
            # but services.redis.servers binds 127.0.0.1 (IPv4) only by
            # default; point at it explicitly rather than fight DNS order.
            database.redis = lib.mkIf (backend == "redis") "redis://127.0.0.1:6379/0";
          };

          # The module can't infer this itself (see database.redis's
          # description) since it doesn't own the backend -- wire it here,
          # where the actual unit name (for this *named* redis instance)
          # is known, to avoid a startup race.
          systemd.services.yopass.after = lib.mkIf (backend == "redis") [ "redis-yopass.service" ];
          systemd.services.yopass.requires = lib.mkIf (backend == "redis") [ "redis-yopass.service" ];
        };

      testScript = ''
        start_all()
        machine.wait_for_unit("yopass.service")
        machine.wait_for_open_port(1337)
        machine.succeed("curl --fail http://localhost:1337 | grep -qi yopass")

        # Round-trip a secret through the real yopass CLI (ships in the
        # same package as yopass-server), exercising create + retrieve
        # against the running server rather than guessing the HTTP API.
        link = machine.succeed(
            "printf 'hello from the nixos test' |"
            " ${yopassCli} --api http://localhost:1337 --url http://localhost:1337"
        ).strip()
        machine.succeed(
            "${yopassCli} --api http://localhost:1337 --url http://localhost:1337"
            f" --decrypt '{link}' | grep -q 'hello from the nixos test'"
        )
      '';
    };
in
{
  memcached = yopassTest {
    name = "memcached";
    backend = "memcached";
  };
  redis = yopassTest {
    name = "redis";
    backend = "redis";
  };
}
